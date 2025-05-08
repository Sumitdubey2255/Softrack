
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class ServicePlan {
  DateTime startDate;
  DateTime endDate;
  int totalDays;
  int usedDays;
  bool isPaused;
  int bonusDays;

  ServicePlan({
    required this.startDate,
    required this.totalDays,
    this.usedDays = 0,
    this.isPaused = false,
    this.bonusDays = 0,
  }) : endDate = startDate.add(Duration(days: totalDays));

  void activateService() {
    if (isPaused) {
      int remainingDays = endDate.difference(DateTime.now()).inDays;
      if (remainingDays > 0) {
        startDate = DateTime.now();
        endDate = startDate.add(Duration(days: remainingDays + bonusDays));
      }
      isPaused = false;
    } else {
      print("Service is already active.");
    }
  }

  void pauseService() {
    if (!isPaused) {
      int daysSinceStart = DateTime.now().difference(startDate).inDays;
      usedDays += daysSinceStart;
      isPaused = true;
      endDate = DateTime.now().add(Duration(days: totalDays - usedDays + bonusDays));
    } else {
      print("Service is already paused.");
    }
  }

  void addBonusDays(int days) {
    bonusDays += days;
    endDate = endDate.add(Duration(days: days));
  }

  void checkServiceStatus() {
    String status = isPaused ? 'paused' : 'active';
    print("${DateTime.now().toLocal().toIso8601String().substring(0, 10)} - $usedDays/$totalDays/$status");

    if (DateTime.now().isAfter(endDate)) {
      print("Service has ended.");
    } else {
      print("Service is active until ${endDate.toLocal()}.");
    }
  }
}

void main() {
  ServicePlan simpleScenario = ServicePlan(startDate: DateTime(2024, 9, 1), totalDays: 10);
  simpleScenario.activateService();
  simpleScenario.pauseService(); // Pause service on 16/08/24
  simpleScenario.addBonusDays(5); // Add 5 days bonus
  simpleScenario.checkServiceStatus();
  print('-------------------------------------------------------------------------------------------');
  ServicePlan terminatingScenario = ServicePlan(startDate: DateTime(2024, 9, 1), totalDays: 10);
  terminatingScenario.activateService();
  terminatingScenario.pauseService(); // Pause on 05/08/24
  terminatingScenario.activateService(); // Reactivate on 20/08/24
  terminatingScenario.checkServiceStatus();
  terminatingScenario.pauseService(); // Pause again on 31/08/24 with bonus days
  terminatingScenario.addBonusDays(5);
  terminatingScenario.checkServiceStatus();
}