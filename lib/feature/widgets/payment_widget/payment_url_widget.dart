import 'package:flutter/material.dart';
import 'package:vivas/_core/platform_manager.dart';
import 'package:vivas/_core/screen_sizer.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PaymentUrlWidget extends StatefulWidget {
  final String paymentUrl;
  final void Function(String url) successCallback;
  final void Function() failCallback;
  final String successUrl;
  final String failUrl;

  const PaymentUrlWidget(
      {required this.paymentUrl,
      required this.successCallback,
      required this.failCallback,
      this.successUrl = "SuccessPayment",
      this.failUrl = "CancelPayment",
      Key? key})
      : super(key: key);

  @override
  State<PaymentUrlWidget> createState() => _PaymentUrlWidgetState();
}

class _PaymentUrlWidgetState extends State<PaymentUrlWidget>
    with ScreenSizer, PlatformManager {
  bool shouldShowProgress = false;
  int loadingProgress = 0;
  late WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingProgress = progress;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _scrollContentIfNeeded();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            var url = request.url.toString();
            if (url.contains(widget.successUrl)) {
              print("url Success stripe : $url");
              widget.successCallback.call(url);
            } else if (url.contains(widget.failUrl)) {
              widget.failCallback.call();
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    initScreenSizer(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        _progressWidget(),
      ],
    );
  }

  Widget _progressWidget() {
    if (loadingProgress == 100) return const EmptyWidget();
    return const LinearProgressIndicator();
  }

  void _scrollContentIfNeeded() {
    if (isOnAndroid()) {
      controller.scrollTo(width.toInt(), 0);
    } else if (isOnIOS()) {
      controller.scrollTo(0, 0);
    }
  }
}
