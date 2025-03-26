class CancelPlanSendModel {
  String reason;

  CancelPlanSendModel(this.reason);

  toMap() {
    return {"Reason": reason};
  }
}
