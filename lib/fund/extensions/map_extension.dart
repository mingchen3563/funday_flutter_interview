import 'package:flutter/foundation.dart';

extension MapExtension<K, V> on Map<K, V> {
  V? getOrElse(K key, V defaultValue) {
    if (containsKey(key)) {
      return this[key];
    }
    debugPrint('key: $key not found, fallback to defaultValue: $defaultValue');
    return defaultValue;
  }
}
