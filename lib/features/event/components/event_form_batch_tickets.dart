import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/components/input_fields/currency_field.dart';
import 'package:link_dance/components/input_fields/date_field.dart';
import 'package:link_dance/components/not_found_card.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/dto/core_dto.dart';
import 'package:link_dance/core/exception/custom_exeptions.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/functions/dialog_functions.dart';
import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:link_dance/core/theme/theme_data.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/model/event_batch_ticket_model.dart';
import 'package:link_dance/features/event/model/event_model.dart';

/**
 * Formulario de cadastro de preço por lote de ingressos de acordo com intervalos de datas
 */
class EventFormBatchTickets extends StatefulWidget {
  EventModel? event;

  EventFormBatchTickets({required Key key, this.event}) : super(key: key);

  @override
  State<EventFormBatchTickets> createState() => EventFormBatchTicketsState();
}

class EventFormBatchTicketsState extends State<EventFormBatchTickets>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();
  final FocusNode _femalePriceFocus = FocusNode();
  final FocusNode _malePriceFocus = FocusNode();

  final TextEditingController _startDateController = TextEditingController();

  final TextEditingController _endDateController = TextEditingController();

  late List<EventBatchTicketModel> _batchTicketList = [];

  late EventHelper eventHelper;

  Map<String, dynamic> _formData = {};
  int _batchTicketType = 0;

  bool hasBatchTicket = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    eventHelper = EventHelper.ctx(context: context);
    if (widget.event != null && widget.event!.eventBatchTicket != null) {
      _batchTicketList = widget.event!.eventBatchTicket!;
      _batchTicketType = 1;
      hasBatchTicket = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _buildForm(),
          sizedBox10(),
          if (_batchTicketType == 1) _buildList()
        ]),
      ),
    );
  }

  Widget _buildList() {
    return Flexible(
      child: Container(
        decoration: box(opacity: 0.5, allBorderRadius: 10),
        height: 200,
        child: Column(children: [
          const Text("Lotes"),
          Flexible(
            child: ListView.builder(
                shrinkWrap: false,
                itemCount: _batchTicketList.length,
                itemBuilder: (BuildContext context, int index) {
                  var backgroundColor = Colors.transparent;
                  if (_batchTicketList.isEmpty) {
                    return DataNotFoundComponent();
                  }
                  if (index % 2 == 0) {
                    backgroundColor = Colors.black38;
                  }
                  return itemBuild(
                      item: _batchTicketList[index],
                      brackgroudColor: backgroundColor,
                      index: index);
                }),
          )
        ]),
      ),
    );
  }

  ListTile itemBuild(
      {required EventBatchTicketModel item,
      Color? brackgroudColor = Colors.transparent,
      required int index}) {
    var textStyle = const TextStyle(fontSize: 14);
    return ListTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(1),
      ),
      tileColor: brackgroudColor,
      leading: const Icon(FontAwesomeIcons.ticket),
      title: Text(
        " ${item.startDate.showString()} até ${item.endDate.showString()}",
        style: textStyle,
      ),
      trailing: IconButton(
          onPressed: () {
            setState(() {
              _batchTicketList.removeAt(index);
            });
          },
          icon: const Icon(
            FontAwesomeIcons.trash,
            size: 16,
            color: Colors.redAccent,
          )),
      subtitle: Row(children: [
        const Icon(FontAwesomeIcons.person),
        Text("R\$ ${item.priceMale}"),
        sizedBox10(),
        const Icon(FontAwesomeIcons.personDress),
        Text("R\$ ${item.priceFemale}")
      ]),
    );
  }

  Container _buildForm() {
    return Container(
      decoration: box(opacity: 0.5, allBorderRadius: 10),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(FontAwesomeIcons.ticket),
                  ),
                  const Text(
                    "Lotes ingressos: ",
                    style: formInputsStyles,
                  ),
                  sizedBoxH15(),
                  Radio(
                      activeColor: Colors.white54,
                      groupValue: _batchTicketType,
                      value: 0,
                      onChanged: (newValue) {
                        setState(() {
                          _batchTicketType = newValue!;
                        });
                        hasBatchTicket = false;
                      }),
                  const Text("Nenhum", style: TextStyle(color: inputField)),
                  Radio<int>(
                      activeColor: Colors.white54,
                      groupValue: _batchTicketType,
                      value: 1,
                      onChanged: (newValue) {
                        setState(() {
                          _batchTicketType = newValue!;
                        });
                        hasBatchTicket = true;
                      }),
                  const Text("Por data", style: TextStyle(color: inputField)),
                ],
              ),
              if (_batchTicketType == 1) _bodyForm()
            ],
          ),
        ),
      ),
    );
  }

  Column _bodyForm() {
    return Column(
      children: [
        DateInputField(
            focusNode: _startDateFocus,
            textController: _startDateController,
            isDatePicker: true,
            onlyFuture: true,
            readOnly: true,
            required: true,
            label: "Início do lote",
            onSaved: (value) {
              _formData['startDate'] = value.toString().parseDateTimestamp();
            }),
        DateInputField(
            focusNode: _endDateFocus,
            textController: _endDateController,
            isDatePicker: true,
            onlyFuture: true,
            required: true,
            label: "Fim do lote",
            onSaved: (value) {
              _formData['endDate'] = value.toString().parseDateTimestamp();
            }),
        Row(
          children: [
            Flexible(
              child: CurrencyInputField(
                  focus: _malePriceFocus,
                  initialValue: _formData['priceMale'].toString().emptyIfNull(),
                  required: true,
                  label: "Preço Homem",
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      _formData['priceMale'] = value.parseDouble();
                    }
                  }),
            ),
            Flexible(
              child: CurrencyInputField(
                  focus: _femalePriceFocus,
                  initialValue:
                      _formData['priceFemale'].toString().emptyIfNull(),
                  required: true,
                  label: "Preço Mulher",
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      _formData['priceFemale'] = value.parseDouble();
                    }
                  }),
            ),
          ],
        ),
        sizedBox15(),
        OutlinedButton(
            onPressed: () {
              _addItemList();
            },
            child: const Text("Adicionar")),
        sizedBox10()
      ],
    );
  }

  void _addItemList() {
    if (!_formIsValid()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState?.save();
    EventBatchTicketModel batchTicket =
        EventBatchTicketModel.fromJson(_formData);

    DateRangeDto currentInputDate =    DateRangeDto(
        startDate: batchTicket.startDate, endDate: batchTicket.endDate);

    if ( !currentInputDate.isValidRange( )) {
      showWarning( context, content: "Datas informadas inválidas. A data de início não pode ser maior que a data de fim!");
      return;
    }
    List<DateRangeDto> rangeDates = _batchTicketList
        .map((item) =>
            DateRangeDto(startDate: item.startDate, endDate: item.endDate))
        .toList();

    Map<String, dynamic> intersectionDates = eventHelper.checkIntersectionDates(
        range: currentInputDate,
        otherDates: rangeDates);

    if (intersectionDates['existIntersection']) {
      DateRangeDto dateIntersection = intersectionDates['dateIntersection'];
      showWarning( context, content: "A data informada esta entre o intervalo ${dateIntersection.toString()} informado anteriormente!");
        return;
    }

    setState(() {
      _batchTicketList.add(EventBatchTicketModel.fromJson(_formData));
      _formKey.currentState?.reset();
    });
    _formData = {};
  }

  bool _formIsValid() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  List<EventBatchTicketModel>? getData() {
    if (!hasBatchTicket) {
      return null;
    }
    List<DateRangeDto> rangeDates = _batchTicketList
        .map((item) =>
            DateRangeDto(startDate: item.startDate, endDate: item.endDate))
        .toList();
    // bool checkIntersectionDates =
    //     eventHelper.checkIntersectionDates(otherDates: rangeDates);

    return _batchTicketList;
  }

  void cleanForm() {
    _formKey.currentState?.reset();
  }
}
