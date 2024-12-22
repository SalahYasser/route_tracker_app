DateTime calculateFutureTime(int secondsToAdd) {

  DateTime now = DateTime.now();

  Duration duration = Duration(seconds: secondsToAdd);
  DateTime futureTime = now.add(duration);
  return futureTime;
}