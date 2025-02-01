import 'database_helper.dart';
import '../models/vendor.dart';

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
}