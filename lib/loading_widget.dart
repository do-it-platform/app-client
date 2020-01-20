import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

StatefulWidget dataLoadingWidget<T>(
    {@required Future<T> dataLoadingFn,
    @required Widget widgetBuildFn(T data)}) {
  return FutureBuilder<T>(
    future: dataLoadingFn,
    builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
      if (snapshot.hasError) {
        return ErrorWidget(snapshot.error);
      } else if (snapshot.hasData) {
        return widgetBuildFn(snapshot.data);
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}
