// lib/features/chat/data/providers/chat_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/chat_supabase_datasource.dart';
import '../repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ✅ إضافة Provider لفحص حالة المصادقة
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange.map((event) => event.session?.user);
});

// ✅ إضافة Provider للمستخدم الحالي (غير متزامن)
final currentUserProvider = Provider<User?>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.currentUser;
});

final chatDatasourceProvider = Provider<ChatSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ChatSupabaseDatasource(client);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final datasource = ref.watch(chatDatasourceProvider);
  return ChatRepositoryImpl(datasource);
});
