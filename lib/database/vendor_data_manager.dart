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
      ),
      Vendor(
        vendorId: 'V002',
        upiId: 'asitmdesai@oksbi',
        name: 'Super Market',
        type: 'small',
      ),
      Vendor(
        vendorId: 'V003',
        upiId: 'vendor3@oksbi',
        name: 'Local Shop',
        type: 'medium',
      ),
    ];

    for (var vendor in vendors) {
      await _dbHelper.insertVendor(vendor);
    }
  }

  Future<void> addSamplePhones() async {
    final phones = [
      Phone(
        name: 'John Store',
        phoneNumber: '1234567890',
        upiId: 'vendor1@oksbi',
      ),
      Phone(
        name: 'Super Market',
        phoneNumber: '0987654321',
        upiId: 'asitmdesai@oksbi',
      ),
      Phone(
        name: 'Local Shop',
        phoneNumber: '1122334455',
        upiId: 'vendor3@okicici',
      ),
    ];

    for (var phone in phones) {
      await _dbHelper.insertPhone(phone);
    }
  }
}