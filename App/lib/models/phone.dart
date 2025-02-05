class Phone {
  final String name;
  final String phoneNumber;
   

  Phone({
    required this.name,
    required this.phoneNumber,
 
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone_number': phoneNumber,
       
    };
  }

  factory Phone.fromMap(Map<String, dynamic> map) {
    return Phone(
      name: map['name'],
      phoneNumber: map['phone_number'],
     
    );
  }
}