import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class BlacklistBottomSheet {
  static Future<bool?> show(
    BuildContext context, {
    required String personName,
    required String documentId,
    required String restrictionReason,
    required String registrationDate,
    String? photoUrl,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black87,
      builder: (_) => _BlacklistAlertSheet(
        personName: personName,
        documentId: documentId,
        restrictionReason: restrictionReason,
        registrationDate: registrationDate,
        photoUrl: photoUrl,
      ),
    );
  }
}

class _BlacklistAlertSheet extends StatelessWidget {
  final String personName;
  final String documentId;
  final String restrictionReason;
  final String registrationDate;
  final String? photoUrl;

  const _BlacklistAlertSheet({
    required this.personName,
    required this.documentId,
    required this.restrictionReason,
    required this.registrationDate,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(height: 18),
            _buildPersonCard(context),
            const SizedBox(height: 12),
            _buildRestrictionReason(context),
            const SizedBox(height: 12),
            _buildDate(),
            const SizedBox(height: 20),
            _buildAcceptButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: (context.isDarkMode ? const Color(0xFF3D1A1A) : const Color(0xFFFEE2E2)),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFE24B4A),
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'ALERTA DE SEGURIDAD',
          style: TextStyle(
            color: Color(0xFFE24B4A),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Persona registrada en Lista Negra detectada',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF888888), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPersonCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.overlayPanel,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto + badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: photoUrl != null
                  ? Image.network(
                      photoUrl!,
                      width: 62,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _photoPlaceholder(context),
                    )
                  : _photoPlaceholder(context),
              ),
            ],
          ),

          const SizedBox(width: 14),

          // Datos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dataField(context, 'NOMBRE COMPLETO', personName),
                const SizedBox(height: 10),
                _dataField(context, 'DOCUMENTO ID', documentId)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder(BuildContext context) {
    return Container(
      width: 62,
      height: 72,
      color: (context.isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFE5E7EB)),
      child: const Icon(Icons.person, color: Color(0xFF666666), size: 32),
    );
  }

  Widget _dataField(BuildContext context, String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 10,
            letterSpacing: 0.4,
          ),
        ),
        if (value != null) ...[
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: context.isDarkMode
                  ? const Color(0xFFF0F0F0)
                  : context.colors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRestrictionReason(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          left: const BorderSide(color: Color(0xFFE24B4A), width: 3),
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: (context.isDarkMode ? const Color(0xFF2A1414) : const Color(0xFFFEF2F2)),
          border: Border.all(color: (context.isDarkMode ? const Color(0xFF5A2020) : const Color(0xFFFCA5A5)), width: 0.5),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Text(
          restrictionReason,
          style: TextStyle(
            color: (context.isDarkMode ? const Color(0xFFF09595) : const Color(0xFFB91C1C)),
            fontSize: 12.5,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 13,
          color: Color(0xFF666666),
        ),
        const SizedBox(width: 6),
        Text(
          'Fecha de registro: ',
          style: const TextStyle(color: Color(0xFF666666), fontSize: 11),
        ),
        Text(
          registrationDate,
          style: const TextStyle(color: Color(0xFF888888), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE24B4A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () => Navigator.pop(context, true),
        child: const Text(
          'Aceptar',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
