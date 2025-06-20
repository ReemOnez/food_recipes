import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension DebounceExtension on TextEditingController {
  String get debouncedSearch {
    final search = useState(text);
    useEffect(() {
      Timer? timer;
      void listener() {
        timer?.cancel();
        timer = Timer(const Duration(milliseconds: 350), () => search.value = text);
      }

      addListener(listener);
      return () {
        timer?.cancel();
        removeListener(listener);
      };
    }, [this]);

    return search.value;
  }
}
