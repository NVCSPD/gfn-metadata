LuaQ  i       @/home/www-data/p4barin/devrel/GFE/NimbusBundle/data/black_desert_online_steam_gfn_pc/streaming_game.lua                E   F@� ��  U�� 	@���  A  @ $   @ 
  J  �� �  A J �� �� bA �A �� b@  � ��   AA �� ��
 AB �� "B J � �B bB � �� � �B �A��@�� � A �A �� 
�J �B �� bB � �� C �B �  A� �B "B��@�
�AA � �� � J�� � C �B � � A� �B 
 AC �� "C J �� � bC � �C � �C �  AD �C 
 A� �� "D bB�"A�J��� � 	 J �B	 ��	 bB � � 	 J �� �� bC �B 
 A�	 � �C D �C "C �B bA����
  A	 �B
 � 
 A	 �� "C J ��	 �C bC �B �A����
 A �	 ��
 
 J �	 �� bC � ��	 D �C "C �A�
�A � �	  J � �	 � �C � �	 AD �C bC "B�J��B � 	 A� � � 	 A� �C 
 A�	 �D "D �C bB�����  A	 � � 
 A	 �D "D J ��	 �� bD �C �B���C A �	 �� 
 J �	 �� bD � ��	 E �D "D �B�
�A� � �	  J � �	 � �D � �	 AE �D bD "C�J��C � 	 A� � � 	 A� �D 
 A�	 �E "E �D bC�����  A	 � � 
 A	 �� "E J ��	 �E bE �D �C�"@ � $@  @ $�  � $�  � $    $@ @  � >          package        path 
       ;../?.lua        require        common        Resolutions        Setting        Resolution        ENUM 	       1280x720        width        height        Display Mode        Full-screen 	       windowed        0        Windowed (Borderless)        1 	       Windowed        2        Texture Quality        Low        textureQuality        Medium        High        Graphics Quality 	       Very Low        graphicOption        Lowest        6        5        4        3        Slightly High 
       Very High        Anti-aliasing        Off        antiAliasing        antiAliasingIndex        On        Depth of Field        dof        Faraway NPCs        Representative        SSAO        Faraway Objects        Tessellation        Display Filter        postFilter        Remove Others Effects        useSelfPlayerEffectOnly        Remove Faraway Effects        useNearestEffectOnly        Upscale        upscaleEnable        Remove others lanterns        useSelfPlayerOnlyLantern        GetConfigFilePath        Current_SplitNameValue        Current_ComposeString        Current_GetCurrentOptions        Current_SetOptions                     #      B � � J   �@  �   � ��Ł  �@܁  E�  �BA\� �A�� �A@� � ��
� E�  ��@\� ��  �CA� "C  �B B���  ��^   �           GetDisplayResolutions        ipairs 	       tostring       �?       x        @       table        insert     #   	   	   	   
                                                                                                          pdm    "          resolutions    "          (for generator)    !          (for state)    !          (for control)    !          i              v              wxh                   �   �            @@ E�  � A�  @  E   F � �   \� Z@   �E   F@� �� �� \@�   �           gfe        GetSpecialPath        GSP_MYDOCUMENTS 	       \ B l a c k   D e s e r t \ G a m e O p t i o n . t x t          FileExists        Error        Cannot get My Documents path!        MYDOCUMENTSPATH_IS_MISSING        �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �             config_path                   �   �        E   F@� �   ��  \ ���   �Z  � �� ����a�  �� �           string        gfind        (.*)%s=%s(.*)        �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �             str               (for generator)              (for state)              (for control)              key              value                   �   �        �   �    � � �   �            =         �   �   �   �   �   �             name               value                    �   �            E@  \�� ��  ��   �           DefaultLoadCfgFile        GetConfigFilePath        Current_SplitNameValue        �   �   �   �   �   �   �             ret                   �   �     
   E   �@  ��� �   �  E�  �� ]  ^    �           DefaultSaveCfgFile        GetConfigFilePath        Current_SplitNameValue        Current_ComposeString     
   �   �   �   �   �   �   �   �   �   �             t     	                                                                                                                                       !   "   "   $   $   $   %   %   &   '   '   '   '   (   (   (   (   )   )   )   *   +   +   -   -   -   .   .   /   0   0   0   0   1   1   1   1   2   2   2   2   3   3   3   3   4   4   4   4   5   5   5   5   6   6   6   7   8   8   :   :   :   :   ;   ;   ;   ;   <   =   =   =   =   =   =   =   >   >   >   >   >   >   ?   @   @   B   B   B   C   C   D   E   E   E   E   F   F   F   G   H   H   J   J   J   K   K   L   M   M   M   M   N   N   N   O   P   P   R   R   R   S   S   T   U   U   U   U   V   V   V   W   X   X   Z   Z   Z   [   [   \   ]   ]   ]   ]   ^   ^   ^   _   `   `   b   b   b   c   c   d   e   e   e   e   f   f   f   g   h   h   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �           