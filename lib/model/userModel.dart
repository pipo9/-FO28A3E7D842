class UserModel {
  String uid;
  String phone;
  String email;
  String fullName;
  String role;
  String address;
  Map wallet;

  UserModel(String uid, Map<String, dynamic> data) {
    this.uid = uid ?? "";
    this.phone = data['phone'] ?? "";
    this.email = data['email'] ?? "";
    this.fullName = data['fullName'] ?? "";
    this.role = data['role'] ?? "";
    this.address = data['address'] ?? "";
    this.wallet = data['wallet']?? {};
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'wallet':wallet
    };
  }
}
