import 'database_helper.dart';
import '../models/vendor.dart';
import '../models/phone.dart';

class VendorDataManager {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addSampleVendors() async {
    final vendors = [
      Vendor(
        vendorId: 'V001',
        upiId: 'vendor1@oksbi',
        name: 'John Store',
        type: 'small',
        phoneNumber: '1234567890', // Add phone number
        location: 'New York',  // Add location
      ),
      Vendor(
        vendorId: 'V002',
        upiId: 'asitmdesai@oksbi',
        name: 'Super Market',
        type: 'small',
        phoneNumber: '0987654321', // Add phone number
        location: 'Los Angeles',  // Add location
      ),
      Vendor(
        vendorId: 'V003',
        upiId: 'vendor3@oksbi',
        name: 'Local Shop',
        type: 'medium',
        phoneNumber: '1122334455', // Add phone number
        location: 'Chicago',  // Add location
      ),
      Vendor(
        vendorId: 'V004',
        upiId: 'adityakharmale7@oksbi',
        name: 'sd Shop',
        type: 'medium',
        phoneNumber: '1122334455', // Add phone number
        location: 'San Francisco',  // Add location
      ),
    ];

    for (var vendor in vendors) {
      await _dbHelper.insertVendor(vendor);
    }
  }

  Future<void> addSamplePhones() async {
    final phones = [
      Phone(
        name: 'Adi',
        phoneNumber: '1234567890',  
      ),
      Phone(
        name: 'Johnny',
        phoneNumber: '0987654321', 
      ),
      Phone(
        name: 'Mac',
        phoneNumber: '1122334455',  
      ),
      Phone(
        name: 'steve',
        phoneNumber: '1122364455',  
      ),
    ];

    for (var phone in phones) {
      await _dbHelper.insertPhone(phone);
    }
  }
}
