class Call {
  String callerId;
  String callerName;
  String callerType;
  String receiverId;
  String receiverName;
  String callerPic;
  String receiverPic;
  String receiverType;
  String channelId;

  Call({
    this.callerId,
    this.callerName,
    this.callerType,
    this.receiverId,
    this.receiverName,
    this.callerPic,
    this.receiverPic,
    this.receiverType,
    this.channelId,
  });

  // to map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["caller_id"] = callerId;
    map["caller_name"] = callerName;
    map['caller_type'] = callerType;
    map['caller_pic'] = callerPic;
    map['receiver_pic'] = receiverPic;
    map["receiver_id"] = receiverId;
    map["receiver_name"] = receiverName;
    map["channel_id"] = channelId;
    return map;
  }

  Call.fromMap(Map<String, dynamic> map) {
    callerId = map["caller_id"];
    callerId = map["caller_id"];
    callerName = map["caller_name"];
    callerType = map["caller_type"];
    callerPic = map['caller_pic'];
    receiverPic = map['receiver_pic'];
    receiverId = map["receiver_id"];
    receiverName = map["receiver_name"];
    receiverType = map["receiver_type"];
    channelId = map["channel_id"];
  }
}
