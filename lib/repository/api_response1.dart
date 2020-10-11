class ApiResponse1<T> {
  Status status;

  T data;
  String message;

  ApiResponse1.loading(this.message) : status = Status.LOADING;

  ApiResponse1.completed(this.data) : status = Status.COMPLETED;

  ApiResponse1.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
