// screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import '../widgets/chat_message_bubble.dart';
import 'dart:async'; // For Timer
import 'dart:math';   // For Random

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final Random _random = Random(); // For random selection

  bool _isBotTyping = false;
  Timer? _suggestionTimer; // Timer for showing suggestions
  final Duration _idleTimeThreshold = const Duration(seconds: 10); // 10 seconds idle

  // --- BIGGER & OPTIMIZED Q&A Database ---
  final Map<List<String>, String> _qaMap = {
    // -----------------------------------------------------------------------
    // SECTION: Greetings & General Chat
    // -----------------------------------------------------------------------
    ['hello', 'hi', 'hey']: 'Hi there! I am your legal assistant for Bangladesh. How can I help you today?',
    ['how are you', 'how r u', 'you good']: 'I am an AI, so I don\'t have feelings, but I\'m ready to assist you!',
    ['who are you', 'what are you', 'what is your name', 'your name']: 'I am an AI legal assistant for Bangladesh, designed to provide general information about legal topics. Always consult a qualified lawyer for specific legal advice.',
    ['your purpose', 'what do you do', 'your function']: 'My purpose is to offer general legal information and guidance for users in Bangladesh, helping them understand their rights and available resources. I cannot provide personalized legal advice.',
    ['thank you', 'thanks', 'thx']: 'You\'re welcome! Is there anything else I can help you with?',
    ['bye', 'goodbye', 'see you later']: 'Goodbye! Have a great day. Remember to consult a lawyer for specific legal matters.',

    // -----------------------------------------------------------------------
    // SECTION: Fundamental Rights & Constitutional Law
    // -----------------------------------------------------------------------
    ['rights', 'fundamental rights', 'my rights']: 'As a legal assistant for Bangladesh, Fundamental Rights are guaranteed by the Constitution of Bangladesh. These include rights to life, liberty, equality, and freedom of speech. What specific right are you interested in?',
    ['equality before law', 'equal rights', 'discrimination']: 'As a legal assistant for Bangladesh, Article 27 of the Constitution guarantees equality before the law and equal protection of the law for all citizens, prohibiting discrimination.',
    ['freedom of speech', 'free speech', 'expression']: 'As a legal assistant for Bangladesh, Article 39 of the Constitution ensures freedom of thought, conscience, and speech, subject to reasonable restrictions in the interest of the security of the state, public order, decency, or morality.',
    ['right to life', 'life liberty', 'personal liberty']: 'As a legal assistant for Bangladesh, Article 32 protects the right to life and personal liberty, stating that no person shall be deprived of life or personal liberty save in accordance with law.',
    ['freedom of movement', 'move freely', 'travel rights']: 'As a legal assistant for Bangladesh, Article 36 guarantees freedom of movement throughout Bangladesh, subject to reasonable restrictions in the public interest.',
    ['freedom of assembly', 'assembly peacefully', 'protest rights']: 'As a legal assistant for Bangladesh, Article 37 grants the right to assemble peacefully and without arms, subject to reasonable restrictions.',
    ['freedom of association', 'form associations', 'union rights']: 'As a legal assistant for Bangladesh, Article 38 allows citizens to form associations or unions, again subject to reasonable restrictions.',
    ['right against exploitation', 'exploitation', 'forced labor', 'torture']: 'As a legal assistant for Bangladesh, Articles 34 and 35 protect citizens from forced labor and ensure the right against torture and inhuman treatment.',
    ['right to property', 'own property', 'land ownership rights']: 'As a legal assistant for Bangladesh, Article 42 generally protects the right to acquire, hold, and dispose of property, subject to law. However, property can be acquired by the state with compensation as per law.',

    // -----------------------------------------------------------------------
    // SECTION: Specific Legal Areas
    // -----------------------------------------------------------------------
    // Consumer Rights
    ['consumer rights', 'consumer protection', 'fraudulent product', 'bad service']: 'As a legal assistant for Bangladesh, you have rights as a consumer protected under the Consumer Rights Protection Act, 2009. This includes the right to safe products, information, choice, and to be heard. You can file complaints with the Directorate of National Consumer Rights Protection.',
    ['file consumer complaint', 'complain about product']: 'As a legal assistant for Bangladesh, you can file a consumer complaint by submitting an application to the Directorate of National Consumer Rights Protection, often with proof of purchase and the nature of the grievance.',

    // Women's & Child Rights
    ['women\'s rights', 'women rights', 'violence against women', 'dowry', 'sexual harassment']: 'As a legal assistant for Bangladesh, women\'s rights are protected by the Constitution and specific laws like the Dowry Prohibition Act, 2018, and the Prevention of Oppression Against Women and Children Act, 2000. For specific advice, consult a lawyer.',
    ['child rights', 'child protection', 'children rights', 'child abuse', 'juvenile justice']: 'As a legal assistant for Bangladesh, child rights are enshrined in the Children Act, 2013, which focuses on protecting children, ensuring their welfare, and providing juvenile justice. This includes rights to education, health, and protection from abuse. Report child abuse to local authorities.',

    // Labour Law
    ['labour law', 'labor law', 'worker rights', 'employment law', 'wage', 'working conditions', 'trade union']: 'As a legal assistant for Bangladesh, labour laws govern employment conditions, wages, and workers\' rights. The Bangladesh Labour Act, 2006, is the primary legislation covering aspects like working hours, leave, safety, and dispute resolution. For detailed information, consult legal experts.',
    ['minimum wage', 'fair wage']: 'As a legal assistant for Bangladesh, the minimum wage is periodically set by the government for various industrial sectors under the Bangladesh Labour Act, 2006. Check the official gazette for the latest rates applicable to your sector.',
    ['workplace safety', 'safety at work']: 'As a legal assistant for Bangladesh, employers are obligated to ensure a safe working environment under the Bangladesh Labour Act, 2006. Workers have the right to refuse unsafe work and report hazards.',

    // Family Law
    ['family law', 'divorce', 'marriage', 'child custody', 'maintenance', 'alimony', 'nikah', 'marriage registration']: 'As a legal assistant for Bangladesh, family law covers marriage, divorce, maintenance, and child custody. Laws vary depending on religious personal laws (e.g., Muslim, Hindu, Christian) and civil laws. For sensitive and specific advice, always seek professional legal counsel.',
    ['get a divorce', 'divorce process', 'talaq', 'khula']: 'As a legal assistant for Bangladesh, the divorce process varies by religion. For Muslims, it can involve "Talaq" (by husband) or "Khula" (by mutual consent/wife\'s initiative). Civil marriages follow the Special Marriage Act. It is highly recommended to consult a family lawyer.',
    ['child custody law', 'custody rights']: 'As a legal assistant for Bangladesh, child custody decisions in divorce cases prioritize the child\'s best interests. Courts consider factors like the child\'s age, wishes (if old enough), and the parents\' ability to provide care. Both parents typically have rights, but one parent is granted physical custody.',

    // Property Law
    ['property law', 'land dispute', 'land ownership', 'inheritance of land', 'land transfer']: 'As a legal assistant for Bangladesh, property law in Bangladesh deals with ownership, transfer, and inheritance of land and other properties. Land disputes are common and often require detailed documentation, survey, and legal proceedings. The State Acquisition and Tenancy Act, 1950, is a key legislation.',
    ['land registration', 'register land', 'deed registration']: 'As a legal assistant for Bangladesh, land registration is a mandatory process under the Registration Act, 1908, to legally transfer ownership of property. It involves drafting a deed, paying stamp duty and registration fees, and submitting documents to the Sub-Registrar\'s office.',
    ['tenant rights', 'landlord rights', 'rent agreement', 'rental dispute', 'eviction']: 'As a legal assistant for Bangladesh, the Rent Control Ordinance, 1991, provides guidelines for tenant and landlord rights and responsibilities, including rental agreements, rent increases, and eviction procedures. Disputes can be resolved through Rent Control Courts.',
    ['inheritance law', 'succession law', 'property division', 'will']: 'As a legal assistant for Bangladesh, inheritance and succession laws vary significantly based on religious affiliation (e.g., Muslim, Hindu, Christian personal laws). This is a complex area; consulting a lawyer for specific family situations is essential.',

    // Cybercrime & Digital Security
    ['cybercrime', 'digital security act', 'online fraud', 'hacking', 'cyber harassment', 'defamation online']: 'As a legal assistant for Bangladesh, cybercrimes are addressed by the Digital Security Act, 2018. It covers offenses like hacking, online harassment, digital fraud, and publishing offensive content. Report such incidents to the Cyber Crime Investigation Center or local law enforcement.',
    ['report cybercrime', 'cyber attack']: 'As a legal assistant for Bangladesh, you can report cybercrime to the Cyber Crime Investigation Center (Bangladesh Police) or your local police station. Collect all evidence like screenshots, links, and messages.',

    // Environmental Law
    ['environmental laws', 'pollution', 'environment protection', 'climate change law', 'eco-friendly']: 'As a legal assistant for Bangladesh, environmental laws aim to protect and improve the environment. The Environment Conservation Act, 1995, and Environment Protection Rules, 1997, are key legislations. Report pollution or violations to the Department of Environment.',

    // Criminal Law & Procedures
    ['criminal law', 'theft', 'murder', 'assault', 'fraud', 'robbery', 'extortion']: 'As a legal assistant for Bangladesh, criminal law deals with offenses against the state, like theft, murder, assault, and fraud. The Penal Code, 1860, defines most offenses, and the Code of Criminal Procedure, 1898, outlines the trial process.',
    ['bail', 'get bail', 'bail application', 'arrested']: 'As a legal assistant for Bangladesh, bail is a temporary release of an accused person from custody, often on condition of appearing in court when required. The process involves filing an application with the court, which considers factors like the severity of the offense, evidence, and flight risk.',
    ['filing a police report', 'fir', 'police case', 'lodge complaint']: 'As a legal assistant for Bangladesh, to file a police report (First Information Report - FIR), you should visit your local police station and provide details of the incident. This initiates a criminal investigation. Ensure you get a copy of the FIR.',
    ['appeal criminal case', 'challenge verdict']: 'As a legal assistant for Bangladesh, an appeal in a criminal case can be filed in a higher court (e.g., High Court Division from a Sessions Court) if you are dissatisfied with a lower court\'s judgment. Specific grounds and timelines apply.',

    // Civil Law & Procedures
    ['civil law', 'contract law', 'dispute resolution', 'compensation', 'damages']: 'As a legal assistant for Bangladesh, civil law deals with disputes between individuals or organizations, seeking remedies like compensation rather than punishment. Examples include contract disputes, property disputes, and torts.',
    ['public interest litigation', 'pil', 'public good lawsuit']: 'As a legal assistant for Bangladesh, Public Interest Litigation (PIL) allows individuals or groups to bring cases before the higher courts (High Court Division of the Supreme Court) to protect broad public interests, such as environmental protection, human rights, or good governance, even if they are not directly aggrieved.',
    ['file civil suit', 'sue someone']: 'As a legal assistant for Bangladesh, filing a civil suit generally involves preparing a plaint (a written statement of claim), filing it with the appropriate civil court, paying court fees, and serving notice to the other party.',

    // Administrative Law
    ['administrative law', 'government action', 'judicial review']: 'As a legal assistant for Bangladesh, administrative law governs the powers and procedures of administrative agencies of the government. Citizens can challenge arbitrary or illegal government actions through judicial review in the High Court Division.',
    ['freedom of information act', 'rti', 'request information']: 'As a legal assistant for Bangladesh, the Right to Information Act, 2009, allows citizens to request information from public authorities to promote transparency and accountability. You can submit formal requests to designated information officers.',

    // Courts & Judicial System
    ['court', 'courts', 'judicial system', 'supreme court', 'high court', 'district court', 'magistrate court']: 'As a legal assistant for Bangladesh, the judicial system includes the Supreme Court (Appellate and High Court Divisions), District Courts (Civil and Criminal), and various specialized tribunals like Labor Courts, Administrative Tribunals, and Family Courts.',
    ['what is a judge', 'role of judge', 'magistrate']: 'As a legal assistant for Bangladesh, a judge presides over legal proceedings, interprets the law, assesses the evidence presented, and controls the courtroom. Their primary role is to ensure justice is administered fairly and impartially.',
    ['what is a lawyer', 'role of lawyer', 'advocate', 'legal counsel']: 'As a legal assistant for Bangladesh, a lawyer (or advocate) represents clients in legal matters, provides legal advice, drafts legal documents, and advocates for their clients\' interests in court.',

    // App-specific interactions
    ['favorites', 'favourite', 'how to save', 'bookmark']: 'You can mark items as favorites from the lists of Rights, Legal Aid, or Legal Guides. Access them through the "Favorites" section on the home screen.',
    ['admin view', 'admin section', 'admin panel']: 'The "Admin View" is for administrative purposes, likely for managing content or system settings by authorized personnel. It\'s not for general users.',
    ['report issue', 'report problem', 'submit issue', 'bug report']: 'To report an issue, please use the "Report Issues" section on the home screen. Describe the issue and optionally attach an image.',
  };
  // --- End of BIGGER & OPTIMIZED Q&A Database ---

  // --- List of all possible unique questions for suggestions ---
  late final List<String> _allPossibleSuggestions;

  @override
  void initState() {
    super.initState();
    // Populate _allPossibleSuggestions from the keys of _qaMap for diverse suggestions
    _allPossibleSuggestions = _qaMap.keys
        .expand((keywords) => keywords) // Flatten the list of keyword lists
        .where((keyword) => keyword.length > 5) // Filter out very short keywords like 'hi'
        .map((keyword) => 'What is ${keyword.trim()}?') // Format them as questions
        .toSet() // Remove duplicates
        .toList();

    // Initial bot message with initial suggestions
    _addBotMessage('Hello! I am your legal assistant. How can I help you today?',
        suggestions: _generateRandomSuggestions(count: 3)); // Show 3 initial suggestions
    _startSuggestionTimer(); // Start the timer
  }

  // --- Timer Management ---
  void _startSuggestionTimer() {
    _suggestionTimer?.cancel(); // Cancel any existing timer
    _suggestionTimer = Timer(_idleTimeThreshold, () {
      if (!_isBotTyping && _messages.isNotEmpty && _messages.last['sender'] == 'bot') {
        _showTimedSuggestions();
      }
      _startSuggestionTimer(); // Restart the timer for continuous suggestions
    });
  }

  void _resetSuggestionTimer() {
    _suggestionTimer?.cancel(); // Cancel the current timer
    _startSuggestionTimer();    // Start a new one
  }

  // --- Dynamic Suggestion Generation Logic ---
  List<String> _generateRandomSuggestions({int count = 4}) {
    // Ensure we don't ask for more suggestions than available
    int actualCount = min(count, _allPossibleSuggestions.length);

    // Shuffle the list and take the first 'actualCount' elements
    final List<String> shuffledList = List.from(_allPossibleSuggestions)..shuffle(_random);
    return shuffledList.take(actualCount).toList();
  }

  void _showTimedSuggestions() {
    // Check if the last bot message already had suggestions to avoid spamming
    if (_messages.isNotEmpty && _messages.last['suggestions'] == null && !_isBotTyping) {
      final List<String> newSuggestions = _generateRandomSuggestions();
      _addBotMessage('Maybe try asking about these topics:', suggestions: newSuggestions);
    }
  }
  // --- End of Timer and Suggestion Management ---

  void _addMessage(String text, String sender, {bool isLoading = false, List<String>? suggestions}) {
    setState(() {
      _messages.add({
        'text': text,
        'sender': sender,
        'timestamp': DateTime.now(),
        'isLoading': isLoading,
        'suggestions': suggestions,
      });
    });
    _scrollToBottom();
  }

  void _addBotMessage(String text, {bool isLoading = false, List<String>? suggestions}) {
    _addMessage(text, 'bot', isLoading: isLoading, suggestions: suggestions);
  }

  void _addOwnMessage(String text) {
    _addMessage(text, 'user');
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    _resetSuggestionTimer(); // Reset timer on user submission

    _textController.clear();
    _addOwnMessage(text);

    if (!_isBotTyping) {
      setState(() {
        _isBotTyping = true;
      });
      _addBotMessage('Typing...', isLoading: true);
      _scrollToBottom();
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        _messages.removeWhere((msg) => msg['isLoading'] == true);
        _isBotTyping = false;
      });
      _getBotResponse(text);
      _startSuggestionTimer(); // Restart timer after bot responds
    });
  }

  void _getBotResponse(String userMessage) {
    String response = 'I\'m not sure how to respond to that. Can you rephrase or ask about legal rights, aid, or guides?';
    List<String>? suggestionsToOffer;

    final lowerCaseMessage = userMessage.toLowerCase();

    for (var entry in _qaMap.entries) {
      for (String keyword in entry.key) {
        if (lowerCaseMessage.contains(keyword)) {
          response = entry.value;
          break;
        }
      }
      if (response != 'I\'m not sure how to respond to that. Can you rephrase or ask about legal rights, aid, or guides?') {
        break;
      }
    }

    // If no specific response was found (still default), offer general suggestions
    if (response == 'I\'m not sure how to respond to that. Can you rephrase or ask about legal rights, aid, or guides?') {
      suggestionsToOffer = _generateRandomSuggestions();
    }

    _addBotMessage(response, suggestions: suggestionsToOffer);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot Assistant'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true,

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ChatMessageBubble(
                  text: message['text']!,
                  sender: message['sender']!,
                  timestamp: message['timestamp']!,
                  isLoading: message['isLoading'] ?? false,
                  suggestions: message['suggestions'] as List<String>?,
                  onSuggestionTap: (tappedSuggestion) {
                    _textController.text = tappedSuggestion; // Put suggestion in input field
                    _handleSubmitted(tappedSuggestion);     // And immediately submit it
                  },
                );
              },
            ),
          ),
          const Divider(height: 1.0),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _buildTextComposer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              onChanged: (text) => _resetSuggestionTimer(), // Reset timer on typing
              decoration: InputDecoration(
                hintText: 'Send a message...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _suggestionTimer?.cancel(); // Cancel timer
    super.dispose();
  }
}