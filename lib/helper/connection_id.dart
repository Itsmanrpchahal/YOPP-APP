String createConnectionId({String myUid, String otherUid}) {
  String connectionId = "";
  if (myUid.compareTo(otherUid) < 0) {
    connectionId = myUid + "_" + otherUid;
  } else {
    connectionId = otherUid + "_" + myUid;
  }
  return connectionId;
}
