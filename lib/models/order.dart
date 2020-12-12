class Order {
  String from;
  String to;
  String fromLocationName;
  String toLocationName;
  String fromContact;
  String toContact;
  String date;
  var amount;

  Order(
      {this.from,
      this.fromContact,
      this.fromLocationName,
      this.to,
      this.toContact,
      this.toLocationName,
      this.amount,
      this.date});

  factory Order.fromJson(Map json) {
    return Order(
        from: json['from'],
        to: json['to'],
        fromContact: json['fromContact'],
        fromLocationName: json['fromLocationName'],
        toContact: json['toContact'],
        toLocationName: json['toLocationName'],
        amount: json['amount'],
        date: json['date']);
  }
}
