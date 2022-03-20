class UserModel {
  String uid;
  String phone;
  String email;
  String fullName;
  String role;
  String address;
  Map wallet;
  String pendingAmount = '0';

  UserModel(String uid, Map<String, dynamic> data) {
    try {
      this.uid = uid ?? "";
      this.phone = data['phone'] ?? "";
      this.email = data['email'] ?? "";
      this.fullName = data['fullName'] ?? "";
      this.role = data['role'] ?? "";
      this.address = data['address'] ?? "";
      this.wallet = data['wallet'] ?? {};

      if (data['role'] == "client") {
        if (wallet.containsKey("transactions")) {
          for (var transaction in data['wallet']['transactions']) {
            if (transaction["status"] == "pending") {
              pendingAmount = (double.parse(pendingAmount) +
                      double.parse(transaction["amount"]))
                  .toString();
            }
          }
        }
      }
    } catch (e) {
      print("######## Error userModel : $e");
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'wallet': wallet
    };
  }
}
