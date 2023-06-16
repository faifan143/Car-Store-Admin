enum JobTypes {
  ADMIN,
  EMPLOYEE,
  DELIVERY,
}

String enumToString(JobTypes jobType) {
  return jobType.toString().split('.').last;
}

JobTypes stringToEnum(String value) {
  return JobTypes.values.firstWhere(
    (type) => type.toString().split('.').last == value,
    orElse: () => JobTypes
        .ADMIN, // Provide a default value or handle the case when the string does not match any enum value
  );
}
