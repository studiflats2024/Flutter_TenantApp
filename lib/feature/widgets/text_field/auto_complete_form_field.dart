/// reface
///https://github.com/jifalops/simple_autocomplete_formfield/blob/master/lib/simple_autocomplete_formfield.dart
// ignore_for_file: overridden_fields

import 'dart:async';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:flutter/services.dart';
import 'package:vivas/feature/widgets/text_field/textfield_state.dart';

typedef SuggestionsBuilder = Widget Function(
    BuildContext context, List<Widget> items);
typedef ItemToString<T> = String Function(T item);
typedef ItemFromString<T> = T? Function(String string);

/// Wraps a [TextFormField] and shows a list of suggestions below it.
///
/// As the user types, a list of suggestions is shown using [onSearch] and
/// [itemBuilder]. The default suggestions container has a fills the available
/// height but can be overridden by using [suggestionsHeight] or by using a
/// custom [suggestionsBuilder].
///
/// It is recommended to provide an [itemFromString] argument so that a
/// suggestion can be selected if the user types in the value instead of tapping
/// on it.
///
/// It is also recommended that the Widget tree containing a
/// SimpleAutocompleteFormField include a [ListView] or other scrolling
/// container such as a [SingleChildScrollView]. This prevents the suggestions
/// from overflowing other UI elements like the keyboard.
class AutocompleteFormField<T> extends FormField<T> {
  @override
  final Key? key;

  /// Minimum search length that shows suggestions.
  final int minSearchLength;

  /// Maximum number of suggestions shown.
  final int maxSuggestions;

  /// Container for the list of suggestions. Defaults to a scrollable `Column`
  /// that fills the available space.
  final SuggestionsBuilder suggestionsBuilder;

  /// The height of the suggestions container. Has no effect if a custom
  ///  [suggestionsBuilder] is specified.
  final double? suggestionsHeight;

  /// Represents an autocomplete suggestion.
  final Widget Function(BuildContext context, T? item) itemBuilder;

  /// How the text field is filled in when an item is selected. If omitted, the
  /// item's `toString()` method is used.
  final ItemToString<T?>? itemToString;

  /// Called before `onChanged` when the input loses focus and a suggestion was
  /// not selected, for example if the user typed in an entire suggestion value
  /// without tapping on it. The default implementation simply returns `null`.
  final ItemFromString<T?>? itemFromString;

  /// Called to fill the autocomplete list's data.
  final Future<List<T?>> Function(String search) onSearch;

  /// Called when an item is tapped or the field loses focus.
  final ValueChanged<T?>? onChanged;

  /// If not null, the TextField [decoration]'s suffixIcon will be
  /// overridden to reset the input using the icon defined here.
  final IconData? resetIcon;

  // TextFormField properties
  @override
  final FormFieldValidator<T?>? validator;
  @override
  final FormFieldSetter<T?>? onSaved;
  final ValueChanged<T?>? onFieldSubmitted;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextAlign textAlign;
  @override
  final T? initialValue;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int? maxLines;
  final int? maxLength;
  final EdgeInsets scrollPadding;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool alwaysShowItem;
  @override
  final bool enabled;

  AutocompleteFormField(
      {this.key,
      this.minSearchLength = 0,
      this.maxSuggestions = 3,
      required this.itemBuilder,
      required this.onSearch,
      this.alwaysShowItem = true,
      SuggestionsBuilder? suggestionsBuilder,
      this.suggestionsHeight,
      this.itemToString,
      this.itemFromString,
      this.onChanged,
      this.resetIcon = Icons.close,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      this.validator,
      this.onFieldSubmitted,
      this.onTap,
      this.onSaved,

      // TextFormField properties
      TextEditingController? controller,
      this.focusNode,
      this.initialValue,
      this.decoration = const InputDecoration(),
      this.keyboardType = TextInputType.text,
      this.style,
      this.textAlign = TextAlign.start,
      this.autofocus = false,
      this.obscureText = false,
      this.autocorrect = true,
      this.maxLengthEnforcement = MaxLengthEnforcement.enforced,
      this.enabled = true,
      this.maxLines = 1,
      this.maxLength,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.textCapitalization = TextCapitalization.none,
      this.inputFormatters})
      : controller = controller ??
            TextEditingController(
                text: _toString<T>(initialValue, itemToString)),
        suggestionsBuilder =
            suggestionsBuilder ?? _defaultSuggestionsBuilder(suggestionsHeight),
        super(
            key: key,
            autovalidateMode: autovalidateMode,
            validator: validator,
            onSaved: onSaved,
            builder: (FormFieldState<T> field) {
              final state = field as _AutocompleteFormFieldState<T>;
              return state.build(state.context);
            });

  @override
  FormFieldState<T> createState() => _AutocompleteFormFieldState<T>();
}

class _AutocompleteFormFieldState<T> extends FormFieldState<T> {
  @override
  AutocompleteFormField<T> get widget =>
      super.widget as AutocompleteFormField<T>;
  List<T> suggestions = [];
  bool showSuggestions = false;
  bool showResetIcon = false;
  T? tappedSuggestion;
  late final TextFieldState state;

  bool get hasFocus => state.focusNode?.hasFocus ?? false;
  bool get hasText => state.controller?.text.isNotEmpty ?? false;

  String get initialText =>
      widget.itemToString?.call(widget.initialValue) ??
      widget.initialValue?.toString() ??
      '';

  void textChanged(String? text) {
    focusChanged(state.focusNode?.hasFocus ?? false);
  }

  void focusChanged(bool? focused) {
    if (focused ?? false) {
      setState(() {
        showSuggestions = (state.controller?.text.trim().length ?? 0) >=
            widget.minSearchLength;
        if (widget.resetIcon != null &&
            state.controller?.text.trim().isEmpty == showResetIcon) {
          showResetIcon = !showResetIcon;
        }
      });
    } else {
      setState(() => showSuggestions = widget.alwaysShowItem);
      setValue(_value);
    }
  }

  @override
  void initState() {
    super.initState();

    showSuggestions = widget.alwaysShowItem;
    state = TextFieldState(
      textChanged: textChanged,
      focusChanged: focusChanged,
      text: initialText,
      controller: widget.controller,
      focusNode: widget.focusNode,
    );
  }

  @override
  void didUpdateWidget(FormField<T> oldWidget) {
    state.update(
        controller: widget.controller,
        focusNode: widget.focusNode,
        text: initialText);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  T? get _value =>
      _toString(tappedSuggestion, widget.itemToString) == state.controller?.text
          ? tappedSuggestion
          : _toObject<T>(state.controller?.text, widget.itemFromString);

  @override
  void setValue(T? value) {
    super.setValue(value);
    if (widget.onChanged != null) widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextFormField(
        controller: state.controller,
        focusNode: state.focusNode,
        decoration: widget.resetIcon == null
            ? widget.decoration
            : widget.decoration?.copyWith(
                suffixIcon: showResetIcon
                    ? IconButton(
                        icon: Icon(widget.resetIcon),
                        onPressed: clear,
                      )
                    : const SizedBox(width: 0.0, height: 0.0),
              ),
        keyboardType: widget.keyboardType,
        style: widget.style,
        textAlign: widget.textAlign,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        scrollPadding: widget.scrollPadding,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        onFieldSubmitted: (value) {
          if (widget.onFieldSubmitted != null) {
            return widget.onFieldSubmitted!(_value);
          }
        },
        validator: (value) {
          if (widget.validator != null) {
            return widget.validator!(_value);
          }
          return null;
        },
        onTap: widget.onTap,
        onSaved: (value) {
          if (widget.onSaved != null) {
            return widget.onSaved!(_value);
          }
        },
      ),
      showSuggestions
          ? FutureBuilder<List<Widget>>(
              future: _buildSuggestions(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return widget.suggestionsBuilder(context, snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          : const SizedBox(height: 0.0, width: 0.0),
    ]);
  }

  Future<List<Widget>> _buildSuggestions() async {
    final list = <Widget>[];
    final suggestions = await widget.onSearch(state.controller?.text ?? "");
    suggestions
        .take(widget.maxSuggestions)
        .forEach((suggestion) => list.add(InkWell(
              child: widget.itemBuilder(context, suggestion),
              onTap: () {
                tappedSuggestion = suggestion;
                state.controller?.text =
                    _toString<T>(suggestion, widget.itemToString);
                state.focusNode?.unfocus();
              },
            )));
    return list;
  }

  void _hideKeyboard() {
    Future.microtask(() => FocusScope.of(context).requestFocus(FocusNode()));
  }

  void clear() async {
    _hideKeyboard();
    // Fix for ripple effect throwing exception
    // and the field staying gray.
    // https://github.com/flutter/flutter/issues/36324
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => state.controller?.clear());
    });
  }
}

String _toString<T>(T? value, ItemToString<T?>? fn) =>
    (fn == null ? value?.toString() : fn(value)) ?? '';

T? _toObject<T>(String? s, ItemFromString<T?>? fn) =>
    fn == null ? null : fn(s ?? '');

SuggestionsBuilder _defaultSuggestionsBuilder(double? height) =>
    // ((context, items) => ListView(children: items));
    ((context, items) => SizedBox(
        height: height,
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items))));
