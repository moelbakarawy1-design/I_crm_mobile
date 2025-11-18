class SalesPerson {
  final String name;
  final int totalCalls;
  final int successfulCalls;
  final int incompleteCalls;

  SalesPerson({
    required this.name,
    required this.totalCalls,
    required this.successfulCalls,
    required this.incompleteCalls,
  });
}

class SalesData {
  static List<SalesPerson> getSalesData() {
    return [
      SalesPerson(name: 'Saif', totalCalls: 30, successfulCalls: 29, incompleteCalls: 1),
      SalesPerson(name: 'Sara', totalCalls: 21, successfulCalls: 18, incompleteCalls: 3),
      SalesPerson(name: 'Huda', totalCalls: 19, successfulCalls: 17, incompleteCalls: 2),
    ];
  }
}