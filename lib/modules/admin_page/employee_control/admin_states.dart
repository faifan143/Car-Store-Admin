abstract class AdminStates {}

class InitialState extends AdminStates {}

class EmployeeCreateSuccessState extends AdminStates {}

class EmployeeCreateErrorState extends AdminStates {
  late final String error;
  EmployeeCreateErrorState({required this.error});
}

class EmployeeCrDeleteSuccessState extends AdminStates {}

class EmployeeDeleteErrorState extends AdminStates {
  late final String error;
  EmployeeDeleteErrorState({required this.error});
}
