import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:link_dance/features/movie/repository/movie_repository.dart';
import 'package:provider/provider.dart';

class DynamicLinkRoutes {
  static Future<void> eventRouter(
      {required BuildContext context,
      required PendingDynamicLinkData linkEvent}) async {
    var eventRepository = Provider.of<EventRepository>(context, listen: false);
    var query = linkEvent.link.queryParameters;
    var eventData =
        await eventRepository.findByIdBase(documentId: query["eventId"]!)!;
    await eventRepository
        .getSubscriptionEvent(eventId: eventData!.id)
        .then((userEvent) {
      Navigator.pushNamed(context, RoutesPages.eventDetail.name,
          arguments: {"event": eventData, "userEvent": userEvent});
    });
  }

  static Future<void> movieRouter(
      {required BuildContext context,
      required PendingDynamicLinkData linkEvent}) async {
    var repository = Provider.of<MovieRepository>(context, listen: false);
    var query = linkEvent.link.queryParameters;
     await repository
        .findByIdBase(documentId: query["movieId"]!)
        .then((movie) => Navigator.pushNamed(
            context, RoutesPages.moviePlay.name,
            arguments: movie));
  }
}
