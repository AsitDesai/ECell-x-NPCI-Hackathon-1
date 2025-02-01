class Phone {
  final String name;
  final String phoneNumber;
  final String upiId;

  Phone({
    required this.name,
    required this.phoneNumber,
    required this.upiId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'upi_id': upiId,
    };
  }

  factory Phone.fromMap(Map<String, dynamic> map) {
    return Phone(
      name: map['name'],
      phoneNumber: map['phone_number'],
      upiId: map['upi_id'],
    );
  }
}