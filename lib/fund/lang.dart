enum Lang {
  //   zh-tw -正體中文
  // zh-cn -簡體中文
  // en -英文
  // ja -日文
  // ko -韓文
  zhTw,
  zhCn,
  en,
  ja,
  ko;

  String get value {
    switch (this) {
      case Lang.zhTw:
        return 'zh-tw';
      case Lang.zhCn:
        return 'zh-cn';
      case Lang.en:
        return 'en';
      case Lang.ja:
        return 'ja';
      case Lang.ko:
        return 'ko';
    }
  }
}
