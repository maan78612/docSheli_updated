class Enums {
  static UserRole role = UserRole();
  static AppointmentType appointmentType = AppointmentType();
  static BookingFor bookingFor = BookingFor();
  static Gender gender = Gender();
  static MessageTypeEnums msgType = MessageTypeEnums();
}

class UserRole {
  int patient = 0, doctor = 1;
}

class FsBuckets {
  static String medicalRecordImage = "Medical Record Image";
}

class AppointmentType {
  int bookAppointment = 0, videoConsultation = 1;
}

class BookingFor {
  int myself = 0, someone = 1;
}

class Gender {
  int male = 0, female = 1;
}

class MessageTypeEnums {
  int text = 0, image = 1, video = 2;
}
