enum EkycLivenessGuide {
  ON_MULTI_FACE("Có nhiều khuôn mặt trong khung hình"),
  ON_NO_FACE ("Giữ điện thoại cố định, đưa khuôn mặt của bạn vào khung hình và nhìn thẳng"),
  FACE_CENTER("Vui lòng nhìn thẳng"),
  LEFT("Vui lòng quay mặt sang bên trái"),
  RIGHT("Vui lòng quay mặt sang bên phải"),
  SMILE("Xin vui lòng hãy cười"),
  OPEN_MOUTH("Vui lòng mở miệng"),
  SURPRISED("Xin vui lòng biểu cảm ngạc nhiên"),
  SADNESS("Xin vui lòng tỏ biểu cảm buồn"),
  NOD_UP("Xin vui lòng ngửa mặt lên"),
  NOD_DOWN("Xin vui lòng ngửa mặt xuống"),
  FACE_FAR("Đưa điện thoại từ từ ra xa và dừng lại khi biểu tượng khuôn mặt màu xanh"),
  DONE("Hoàn thành"),
  FACE_NEAR("Đưa điện thoại từ từ lại gần và dừng lại biểu tượng khuôn mặt màu xanh");

  final String guide;

  const EkycLivenessGuide(this.guide);
}
