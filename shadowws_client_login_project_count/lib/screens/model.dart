class Client {
  String? id;
  String? category;
  String? fName;
  String? dName;
  String? uName;
  String? email;
  String? password;
  String? mobile;
  String? countryId;
  String? countryMobileCode;
  String? alterMobile;
  String? clientId;
  String? gender;
  String? companyName;
  String? gstNo;
  String? location;
  String? taxReg;
  String? panNo;
  String? primaryAddr;
  String? sameAdd;
  String? secondatyAddr;
  String? image;
  String? quoId;
  String? status;
  String? sms;
  String? mail;
  String? createdBy;
  String? chatOnlineStatus;
  String? createdAt;
  Null notifyId;

 Client(
      { this.id,
         this.category,
         this.fName,
         this.dName,
         this.uName,
         this.email,
         this.password,
         this.mobile,
         this.countryId,
         this.countryMobileCode,
         this.alterMobile,
         this.clientId,
         this.gender,
         this.companyName,
         this.gstNo,
         this.location,
         this.taxReg,
         this.panNo,
         this.primaryAddr,
         this.sameAdd,
         this.secondatyAddr,
         this.image,
         this.quoId,
         this.status,
         this.sms,
         this.mail,
         this.createdBy,
         this.chatOnlineStatus,
         this.createdAt,
        this.notifyId});

 Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    fName = json['f_name'];
    dName = json['d_name'];
    uName = json['u_name'];
    email = json['email'];
    password = json['password'];
    mobile = json['mobile'];
    countryId = json['country_id'];
    countryMobileCode = json['country_mobile_code'];
    alterMobile = json['alter_mobile'];
    clientId = json['client_id'];
    gender = json['gender'];
    companyName = json['company_name'];
    gstNo = json['gst_no'];
    location = json['location'];
    taxReg = json['tax_reg'];
    panNo = json['pan_no'];
    primaryAddr = json['primary_addr'];
    sameAdd = json['same_add'];
    secondatyAddr = json['secondaty_addr'];
    image = json['image'];
    quoId = json['quo_id'];
    status = json['status'];
    sms = json['sms'];
    mail = json['mail'];
    createdBy = json['created_by'];
    chatOnlineStatus = json['chat_online_status'];
    createdAt = json['created_at'];
    notifyId = json['notify_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['f_name'] = this.fName;
    data['d_name'] = this.dName;
    data['u_name'] = this.uName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile'] = this.mobile;
    data['country_id'] = this.countryId;
    data['country_mobile_code'] = this.countryMobileCode;
    data['alter_mobile'] = this.alterMobile;
    data['client_id'] = this.clientId;
    data['gender'] = this.gender;
    data['company_name'] = this.companyName;
    data['gst_no'] = this.gstNo;
    data['location'] = this.location;
    data['tax_reg'] = this.taxReg;
    data['pan_no'] = this.panNo;
    data['primary_addr'] = this.primaryAddr;
    data['same_add'] = this.sameAdd;
    data['secondaty_addr'] = this.secondatyAddr;
    data['image'] = this.image;
    data['quo_id'] = this.quoId;
    data['status'] = this.status;
    data['sms'] = this.sms;
    data['mail'] = this.mail;
    data['created_by'] = this.createdBy;
    data['chat_online_status'] = this.chatOnlineStatus;
    data['created_at'] = this.createdAt;
    data['notify_id'] = this.notifyId;
    return data;
  }
}
