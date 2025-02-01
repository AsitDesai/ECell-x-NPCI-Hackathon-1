class Vendor {
  final String vendorId;
  final String upiId;
  final String name;
  final String type;

  Vendor({
    required this.vendorId,
    required this.upiId,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'vendor_id': vendorId,
      'upi_id': upiId,
      'name': name,
      'type': type,
    };
  }

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      vendorId: map['vendor_id'],
      upiId: map['upi_id'],
      name: map['name'],
      type: map['type'],
    );
  }
}