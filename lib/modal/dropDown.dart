class DropDownbookingAppointment {
  int? id;
  String? value;

  DropDownbookingAppointment({this.id, this.value});

  DropDownbookingAppointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}
