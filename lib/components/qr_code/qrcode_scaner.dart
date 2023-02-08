import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/components/qr_code/qr_code_helper.dart';
import 'package:link_dance/components/qr_code/ticket_detail_componente.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/event/ticket/event_ticket_model.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class QrCodeScannerComponent extends StatefulWidget {
  @override
  State<QrCodeScannerComponent> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScannerComponent> {
  late MobileScannerController cameraController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraController = MobileScannerController();
  }

  late AuthenticationFacate auth;

  @override
  void didChangeDependencies() {
    auth = Provider.of<AuthenticationFacate>(context, listen: false);

    super.didChangeDependencies();
  }

  bool bockPopUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Validar QRCode"),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(FontAwesomeIcons.listCheck),
              iconSize: 18,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
            allowDuplicates: true,
            controller: cameraController,
            fit: BoxFit.cover,
            onDetect: (barcode, args) {
              if (barcode.rawValue == null) {
                debugPrint('Failed to scan Barcode');
                return;
              }
              if (bockPopUp) {
                return;
              }
              bockPopUp = true;
              EventTicketDTO eventTicket =
                  EventTicketDTO.parseToModel(queryParam: barcode.rawValue!);
              var ticketData = QrCodeEventTicketHelper(auth: auth)
                  .getEventTicket(requestParam: eventTicket);

              print("ticketData is ${ticketData.toString()}");

              cameraController.stop();

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TicketDetailComponent(
                      onClose: () {
                        bockPopUp = false;
                        cameraController.start();
                      },
                    );
                  });
            }));
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
