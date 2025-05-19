///This class identifies the type of document you have verified
enum CardTypeEnums {
  FRONT_ID_CARD_9("9_id_card_front", "CMND"),
  BACK_ID_CARD_9("9_id_card_back", "CMND"),
  FRONT_ID_CARD_12("12_id_card_front", "CCCD 12 số"),
  BACK_ID_CARD_12("12_id_card_back", "CCCD 12 số"),
  FRONT_CHIP_ID_CARD("chip_id_card_front", "CCCD Gắn chip"),
  BACK_CHIP_ID_CARD("chip_id_card_back", "CCCD Gắn chip"),
  PASSPORT("passport", "Hộ chiếu"),
  EID("EID", "Thẻ căn cước công dân"),
  NEW_EID("NEW_EID", "Thẻ căn cước"),
  UNKNOWN("unknown", "unknown");

  final String type;
  final String define;

  const CardTypeEnums(this.type, this.define);

  static String? getType(String type) {
    for (var card in CardTypeEnums.values) {
      if (card.type == type) {
        return card.define;
      }
    }
    return UNKNOWN.define;
  }
}
