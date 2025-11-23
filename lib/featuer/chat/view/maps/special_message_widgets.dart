import 'package:admin_app/featuer/chat/view/maps/helper/helper_location.dart';
import 'package:admin_app/featuer/chat/view/maps/widgets/location_widget_constants.dart';
import 'package:admin_app/featuer/chat/view/maps/widgets/location_widget_styles.dart';
import 'package:admin_app/featuer/chat/view/maps/widgets/map_grid_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class LocationMessageWidget extends StatefulWidget {
  final String locationContent; 

  const LocationMessageWidget({super.key, required this.locationContent});

  @override
  State<LocationMessageWidget> createState() => _LocationMessageWidgetState();
}

class _LocationMessageWidgetState extends State<LocationMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _pulseController = AnimationController(
      duration: LocationWidgetConstants.pulseAnimationDuration,
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: LocationWidgetConstants.pulseScaleMin,
      end: LocationWidgetConstants.pulseScaleMax,
    ).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    LocationWidgetHelpers.openMap(widget.locationContent);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: LocationWidgetConstants.hoverAnimationDuration,
          curve: Curves.easeOutCubic,
          width: LocationWidgetConstants.containerWidth.w,
          height: LocationWidgetConstants.containerHeight.h,
          decoration: LocationWidgetStyles.getContainerDecoration(_isHovered),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              LocationWidgetConstants.borderRadius.r,
            ),
            child: Stack(
              children: [
                _buildBackground(),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: MapGridPainter(
          color: LocationWidgetStyles.getGridColor(_isHovered),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(LocationWidgetConstants.contentPadding.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildLocationPin(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildMapIcon(),
        const Spacer(),
        _buildLiveBadge(),
      ],
    );
  }

  Widget _buildMapIcon() {
    return Container(
      padding: EdgeInsets.all(LocationWidgetConstants.pinContainerPadding.w),
      decoration: LocationWidgetStyles.getHeaderIconDecoration(_isHovered),
      child: Icon(
        Icons.map_rounded,
        size: LocationWidgetConstants.headerIconSize.sp,
        color: LocationWidgetStyles.getHeaderIconColor(_isHovered),
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: LocationWidgetConstants.badgeHorizontalPadding.w,
        vertical: LocationWidgetConstants.badgeVerticalPadding.h,
      ),
      decoration: LocationWidgetStyles.getLiveBadgeDecoration(_isHovered),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: LocationWidgetConstants.liveIndicatorSize.sp,
            color: LocationWidgetStyles.getLiveIndicatorColor(_isHovered),
          ),
          SizedBox(width: 4.w),
          Text(
            LocationWidgetConstants.liveText,
            style: LocationWidgetStyles.getLiveBadgeTextStyle(_isHovered),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPin() {
    return SizedBox(
      height: LocationWidgetConstants.pinPulseSize.h,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildPulseEffect(),
            _buildPinIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseEffect() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: LocationWidgetConstants.pinPulseSize.w *
              _pulseAnimation.value,
          height: LocationWidgetConstants.pinPulseSize.h *
              _pulseAnimation.value,
          decoration: LocationWidgetStyles.getPulseDecoration(
            _isHovered,
            _pulseAnimation.value,
          ),
        );
      },
    );
  }

  Widget _buildPinIcon() {
    return Container(
      padding: EdgeInsets.all(LocationWidgetConstants.pinContainerPadding.w),
      decoration: LocationWidgetStyles.getLocationPinDecoration(_isHovered),
      child: Icon(
        Icons.location_on,
        color: LocationWidgetStyles.getLocationPinIconColor(_isHovered),
        size: LocationWidgetConstants.locationPinSize.sp,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildCoordinatesInfo()),
        _buildArrowIcon(),
      ],
    );
  }

  Widget _buildCoordinatesInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocationWidgetConstants.locationLabel,
          style: LocationWidgetStyles.getLocationLabelTextStyle(_isHovered),
        ),
        SizedBox(height: 2.h),
        Text(
          LocationWidgetHelpers.formatCoordinates(widget.locationContent),
          style: LocationWidgetStyles.getCoordinatesTextStyle(_isHovered),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildArrowIcon() {
    return Icon(
      Icons.arrow_forward_rounded,
      size: LocationWidgetConstants.arrowIconSize.sp,
      color: LocationWidgetStyles.getArrowIconColor(_isHovered),
    );
  }
}