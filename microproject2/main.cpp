#include <semaphore.h>

#include <chrono>
#include <fstream>
#include <memory>
#include <mutex>
#include <queue>
#include <random>
#include <string>
#include <thread>
#include <vector>

// Когда начинаешь называть переменные кириллицой, очень сложно остановиться.
constexpr int количествоПеренаправителей = 2;

struct Пациент {
  std::shared_ptr<sem_t> semaphore;
  std::shared_ptr<int> nextВрачId;
  int id;
};

struct Врач {
  std::string name;
  int id;
  bool isSpecialist;
  sem_t semaphore;
  std::queue<Пациент> queue;
  std::shared_ptr<std::thread> thread;
  std::shared_ptr<std::mutex> queueMutex;
  std::mt19937 random;

  Врач(std::string name, int id) : name(name), id(id), random(id+1000) {
    sem_init(&semaphore, 0, 0);
    isSpecialist = name.find("№") == std::string::npos;
    queueMutex = std::make_shared<std::mutex>();
  }

  void start(){
    thread = std::make_shared<std::thread>(&Врач::work, this);
  }

  void work();

  void enqueue(Пациент пациент) {
    queueMutex->lock();
    queue.push(пациент);
    queueMutex->unlock();
    sem_post(&semaphore);
  }

  Пациент dequeue() {
    sem_wait(&semaphore);
    Пациент res;
    queueMutex->lock();
    if(queue.size() != 0){
      res = queue.front();
      queue.pop();
    }
    queueMutex->unlock();
    return res;
  }
};

std::vector<Врач> врачи = {
  {"Приниматель №1", 0},
  {"Приниматель №2", 1},
  {"Стоматолог", 2},
  {"Хирург", 3},
  {"Терапевт", 4},
};

int random(int min, int max, int seed) {
  std::mt19937 gen(seed);
  std::uniform_int_distribution<int> dis(min, max - 1);
  return dis(gen);
}

int встатьВОчередь(std::shared_ptr<sem_t> sem, Врач& врач, int id) {
  auto nextВрач = std::make_shared<int>();
  врач.enqueue({sem, nextВрач, id});
  printf("Пациент №%d встал в очередь к %s\n", id, врач.name.c_str());
  sem_wait(sem.get());
  return *nextВрач;
}

void пациент(int id) {
  std::this_thread::sleep_for(std::chrono::milliseconds(random(1, 10, id)));
  printf("Пациент №%d пришёл в больницу\n", id);

  auto sem = std::make_shared<sem_t>();
  sem_init(sem.get(), 0, 0);
  auto nextId = встатьВОчередь(sem, врачи[random(0, 2, id)], id);
  встатьВОчередь(sem, врачи[nextId], id);

  printf("Пациента №%d очень хорошо вылечили, он уходит из больницы\n", id);
}

void Врач::work() {
  static std::uniform_int_distribution<int> dist(количествоПеренаправителей, (int)врачи.size()-1);

  while(true) {
    Пациент victim = dequeue();
    if(victim.nextВрачId == nullptr)return;
    if(isSpecialist) {
      printf("%s \"вылечил\"  пациента №%d\n", name.c_str(), victim.id);
    } else {
      int nextId = dist(random);
      *victim.nextВрачId = nextId;
      printf("%s направил пациента №%d к %sу\n", name.c_str(), victim.id, врачи[nextId].name.c_str());
    }
    sem_post(victim.semaphore.get());
  }
}

int main() {
  for(auto&& e : врачи) {
    e.start();
  }
  std::vector<std::thread> пациенты;
  for(int i = 0; i < 10; i++) {
    пациенты.emplace_back(пациент, i + 1);
  }

  for(auto&& e : пациенты) {
    e.join();
  }

  for(auto&& e : врачи) {
    sem_post(&e.semaphore);
    e.thread->join();
  }

  return 0;
}
