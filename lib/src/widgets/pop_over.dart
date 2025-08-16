import 'package:flutter/widgets.dart';

typedef OmarchyPopOverChildWidgetBuilder =
    Widget Function(BuildContext context, VoidCallback show);
typedef OmarchyPopOverWidgetBuilder =
    Widget Function(BuildContext context, Size? size, VoidCallback hide);

class OmarchyPopOver extends StatefulWidget {
  const OmarchyPopOver({
    super.key,
    required this.builder,
    required this.popOverBuilder,
    this.showWhenUnlinked = false,
    this.offset = Offset.zero,
    this.popOverAnchor = Alignment.topLeft,
    this.childAnchor = Alignment.topLeft,
  });

  final OmarchyPopOverChildWidgetBuilder builder;
  final OmarchyPopOverWidgetBuilder popOverBuilder;
  final bool showWhenUnlinked;
  final Offset offset;
  final Alignment popOverAnchor;
  final Alignment childAnchor;

  @override
  State<OmarchyPopOver> createState() => _OmarchyPopOverState();
}

class _OmarchyPopOverState extends State<OmarchyPopOver> {
  final _link = LayerLink();
  final _controller = OverlayPortalController();

  @override
  void didUpdateWidget(covariant OmarchyPopOver oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (BuildContext context) {
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    _controller.hide();
                  },
                  child: Container(color: Color(0x01000000)),
                ),
              ),
              CompositedTransformFollower(
                link: _link,
                showWhenUnlinked: widget.showWhenUnlinked,
                offset: widget.offset,
                targetAnchor: widget.childAnchor,
                followerAnchor: widget.popOverAnchor,
                child: IntrinsicHeight(
                  child: IntrinsicWidth(
                    child: widget.popOverBuilder(
                      context,
                      _link.leaderSize,
                      _controller.hide,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: widget.builder(context, _controller.show),
      ),
    );
  }
}
