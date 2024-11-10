import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wave_mobile_flutter/api/client.dart';
import 'package:wave_mobile_flutter/dto/transaction_response.dart';
import 'package:wave_mobile_flutter/ui/pages/home_page.dart';

class TransactionDetailsPage extends StatefulWidget {
  final TransactionDTOResponse transaction;

  const TransactionDetailsPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  static const primaryColor = Color(0xFF6C63FF);

  bool _canCancelTransaction() {
    final now = DateTime.now();
    final createdAt = widget.transaction.createdAt;
    final difference = now.difference(createdAt);

    return difference.inMinutes <= 30 &&
        widget.transaction.etatTransaction != EtatTransactionEnum.ANNULER;
  }

  void _handleCancelTransaction() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer l\'annulation'),
          content: Text('Voulez-vous vraiment annuler cette transaction ?'),
          actions: [
            TextButton(
              child: Text('Non'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () async {
                print(widget.transaction.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Annulation en cours...'),
                    backgroundColor: primaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                print(widget.transaction.id);
                final dynamic result = await ClientFetch.annulerTransfertClient(
                    widget.transaction.id);

                if (result["status"] == "OK") {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result["message"]),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStatusHeader(),
            _buildTransactionDetails(),
            _buildParticipantDetails(),
            _buildTimestamps(),
            if (_canCancelTransaction()) _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    Color statusColor = _getStatusColor(widget.transaction.etatTransaction);
    IconData statusIcon = _getStatusIcon(widget.transaction.etatTransaction);

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor.withOpacity(0.8), statusColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(statusIcon, size: 48, color: Colors.white),
          SizedBox(height: 12),
          Text(
            '${widget.transaction.montantEnvoye.toStringAsFixed(2)} FCFA',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.transaction.etatTransaction.toString().split('.').last,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Transaction ID', '#${widget.transaction.id}'),
            _buildDetailRow('Type',
                widget.transaction.typeTransaction.toString().split('.').last),
            _buildDetailRow(
                'Amount Sent', '${widget.transaction.montantEnvoye} FCFA'),
            _buildDetailRow(
                'Amount Received', '${widget.transaction.montantRecus} FCFA'),
            if (widget.transaction.fraisValeur != null)
              _buildDetailRow('Fees', '${widget.transaction.fraisValeur} FCFA'),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantDetails() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participants',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildParticipantRow(
              Icons.arrow_upward,
              Colors.red,
              'Sender',
              widget.transaction.senderName ?? '',
              widget.transaction.senderId.toString(),
            ),
            Divider(),
            _buildParticipantRow(
              Icons.arrow_downward,
              Colors.green,
              'Receiver',
              widget.transaction.receiverName ?? '',
              widget.transaction.receiverId.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestamps() {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timestamps',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow(
              'Created',
              dateFormat.format(widget.transaction.createdAt),
              icon: Icons.access_time,
            ),
            if (widget.transaction.updatedAt != null)
              _buildDetailRow(
                'Updated',
                dateFormat.format(widget.transaction.updatedAt!),
                icon: Icons.update,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.grey),
            SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantRow(
    IconData icon,
    Color color,
    String label,
    String name,
    String id,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                'ID: $id',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(EtatTransactionEnum status) {
    switch (status) {
      case EtatTransactionEnum.EFFECTUE:
        return Colors.green;
      case EtatTransactionEnum.ANNULER:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(EtatTransactionEnum status) {
    switch (status) {
      case EtatTransactionEnum.EFFECTUE:
        return Icons.check_circle;
      case EtatTransactionEnum.ANNULER:
        return Icons.access_time;
      default:
        return Icons.info;
    }
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _handleCancelTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Annuler la transaction',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
