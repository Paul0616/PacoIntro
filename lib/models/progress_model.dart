class ProgressModel{
  int current;
  int max;

  ProgressModel(this.current, this.max);

  double get ratio => (current / max);
}