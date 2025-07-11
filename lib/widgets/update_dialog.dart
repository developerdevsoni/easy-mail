import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';
import 'dart:io';
import '../utils/app_theme.dart';
import '../services/force_update_service.dart';

class UpdateDialog {
  static void show({
    required UpdateStatus updateStatus,
    required Map<String, dynamic> updateConfig,
  }) {
    Get.dialog(
      _UpdateDialogWidget(
        updateStatus: updateStatus,
        updateConfig: updateConfig,
      ),
      barrierDismissible: updateStatus != UpdateStatus.forceUpdate,
      barrierColor: Colors.black.withOpacity(0.6),
    );
  }
}

class _UpdateDialogWidget extends StatefulWidget {
  final UpdateStatus updateStatus;
  final Map<String, dynamic> updateConfig;

  const _UpdateDialogWidget({
    required this.updateStatus,
    required this.updateConfig,
  });

  @override
  State<_UpdateDialogWidget> createState() => _UpdateDialogWidgetState();
}

class _UpdateDialogWidgetState extends State<_UpdateDialogWidget> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isForceUpdate = widget.updateStatus == UpdateStatus.forceUpdate;
    
    return PopScope(
      canPop: !isForceUpdate,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 340.w,
                    minHeight: 400.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.textPrimary,
                        AppTheme.backgroundDark.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryPurple.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(isForceUpdate),
                      _buildContent(isForceUpdate),
                      _buildButtons(isForceUpdate),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isForceUpdate) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: isForceUpdate 
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFF6B6B),
                const Color(0xFFFF8E8E),
              ],
            )
          : AppTheme.primaryGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppTheme.textPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isForceUpdate ? Icons.priority_high_rounded : Icons.update_rounded,
              color: AppTheme.textPrimary,
              size: 40.r,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            isForceUpdate 
              ? (widget.updateConfig['force_update_title'] ?? 'Update Required')
              : (widget.updateConfig['update_title'] ?? 'Update Available'),
            style: AppTheme.heading2.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isForceUpdate) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          // Update message
          Text(
            isForceUpdate 
              ? (widget.updateConfig['force_update_message'] ?? 
                'This version is no longer supported. Please update to continue.')
              : (widget.updateConfig['update_message'] ?? 
                'A new version is available. Please update to continue using the app.'),
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 20.h),
          
          // Version info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Version',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      ForceUpdateService().getCurrentVersion(),
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: AppTheme.primaryPurple,
                  size: 20.r,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Latest Version',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.updateConfig['current_version'] ?? '1.0.0',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Changelog
          if (widget.updateConfig['changelog'] != null) ...[
            SizedBox(height: 20.h),
            _buildChangelog(),
          ],
        ],
      ),
    );
  }

  Widget _buildChangelog() {
    final changelog = widget.updateConfig['changelog'] as List<dynamic>;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.warningOrange.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.new_releases_outlined,
                color: AppTheme.warningOrange,
                size: 16.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'What\'s New',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...changelog.take(3).map((item) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4.w,
                  height: 4.w,
                  margin: EdgeInsets.only(top: 6.h, right: 8.w),
                  decoration: const BoxDecoration(
                    color: AppTheme.warningOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.toString(),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildButtons(bool isForceUpdate) {
    return Padding(
      padding: EdgeInsets.all(24.w).copyWith(top: 0),
      child: Column(
        children: [
          // Update button
          GestureDetector(
            onTap: _handleUpdateTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                gradient: isForceUpdate 
                  ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFFFF6B6B),
                        const Color(0xFFFF8E8E),
                      ],
                    )
                  : AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: (isForceUpdate ? const Color(0xFFFF6B6B) : AppTheme.primaryPurple)
                        .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.updateConfig['update_button_text'] ?? 'Update Now',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
          
          // Later button (only for normal updates)
          if (!isForceUpdate) ...[
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppTheme.textPrimary,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppTheme.textTertiary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.updateConfig['later_button_text'] ?? 'Later',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleUpdateTap() async {
    final storeUrl = widget.updateConfig['store_url'] as String?;
    
    if (storeUrl != null && storeUrl.isNotEmpty) {
      final uri = Uri.parse(storeUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to app settings
        AppSettings.openAppSettings(type: AppSettingsType.settings);
      }
    } else {
      // Open app store/play store directly
      if (Platform.isIOS) {
        AppSettings.openAppSettings(type: AppSettingsType.settings);
      } else {
        AppSettings.openAppSettings(type: AppSettingsType.settings);
      }
    }
  }
} 