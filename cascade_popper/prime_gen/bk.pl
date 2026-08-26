%% ============================================================
%% BACKGROUND KNOWLEDGE: Prime Number CLOSED-FORM Formula
%% Target: f(N, P) - P is the N-th prime number
%%
%% CONSTRAINT: Only arithmetic operations provided.
%%   NO recursion helpers, NO primality testing, NO next_prime.
%%   The system MUST compose a formula P = g(N) from arithmetic.
%%
%% Known approximations from number theory:
%%   - Prime Number Theorem: p(n) ~ n * ln(n)
%%   - Better: p(n) ~ n * ln(n) + n * ln(ln(n)) - n
%%   - Cipolla: p(n) ~ n*(ln(n) + ln(ln(n)) - 1 + (ln(ln(n))-2)/ln(n))
%% ============================================================

%% --- Number Domain (1..1000) ---
num(1). num(2). num(3). num(4). num(5). num(6). num(7). num(8). num(9). num(10). num(11). num(12). num(13). num(14). num(15).
num(16). num(17). num(18). num(19). num(20). num(21). num(22). num(23). num(24). num(25). num(26). num(27). num(28). num(29). num(30).
num(31). num(32). num(33). num(34). num(35). num(36). num(37). num(38). num(39). num(40). num(41). num(42). num(43). num(44). num(45).
num(46). num(47). num(48). num(49). num(50). num(51). num(52). num(53). num(54). num(55). num(56). num(57). num(58). num(59). num(60).
num(61). num(62). num(63). num(64). num(65). num(66). num(67). num(68). num(69). num(70). num(71). num(72). num(73). num(74). num(75).
num(76). num(77). num(78). num(79). num(80). num(81). num(82). num(83). num(84). num(85). num(86). num(87). num(88). num(89). num(90).
num(91). num(92). num(93). num(94). num(95). num(96). num(97). num(98). num(99). num(100). num(101). num(102). num(103). num(104). num(105).
num(106). num(107). num(108). num(109). num(110). num(111). num(112). num(113). num(114). num(115). num(116). num(117). num(118). num(119). num(120).
num(121). num(122). num(123). num(124). num(125). num(126). num(127). num(128). num(129). num(130). num(131). num(132). num(133). num(134). num(135).
num(136). num(137). num(138). num(139). num(140). num(141). num(142). num(143). num(144). num(145). num(146). num(147). num(148). num(149). num(150).
num(151). num(152). num(153). num(154). num(155). num(156). num(157). num(158). num(159). num(160). num(161). num(162). num(163). num(164). num(165).
num(166). num(167). num(168). num(169). num(170). num(171). num(172). num(173). num(174). num(175). num(176). num(177). num(178). num(179). num(180).
num(181). num(182). num(183). num(184). num(185). num(186). num(187). num(188). num(189). num(190). num(191). num(192). num(193). num(194). num(195).
num(196). num(197). num(198). num(199). num(200). num(201). num(202). num(203). num(204). num(205). num(206). num(207). num(208). num(209). num(210).
num(211). num(212). num(213). num(214). num(215). num(216). num(217). num(218). num(219). num(220). num(221). num(222). num(223). num(224). num(225).
num(226). num(227). num(228). num(229). num(230). num(231). num(232). num(233). num(234). num(235). num(236). num(237). num(238). num(239). num(240).
num(241). num(242). num(243). num(244). num(245). num(246). num(247). num(248). num(249). num(250). num(251). num(252). num(253). num(254). num(255).
num(256). num(257). num(258). num(259). num(260). num(261). num(262). num(263). num(264). num(265). num(266). num(267). num(268). num(269). num(270).
num(271). num(272). num(273). num(274). num(275). num(276). num(277). num(278). num(279). num(280). num(281). num(282). num(283). num(284). num(285).
num(286). num(287). num(288). num(289). num(290). num(291). num(292). num(293). num(294). num(295). num(296). num(297). num(298). num(299). num(300).
num(301). num(302). num(303). num(304). num(305). num(306). num(307). num(308). num(309). num(310). num(311). num(312). num(313). num(314). num(315).
num(316). num(317). num(318). num(319). num(320). num(321). num(322). num(323). num(324). num(325). num(326). num(327). num(328). num(329). num(330).
num(331). num(332). num(333). num(334). num(335). num(336). num(337). num(338). num(339). num(340). num(341). num(342). num(343). num(344). num(345).
num(346). num(347). num(348). num(349). num(350). num(351). num(352). num(353). num(354). num(355). num(356). num(357). num(358). num(359). num(360).
num(361). num(362). num(363). num(364). num(365). num(366). num(367). num(368). num(369). num(370). num(371). num(372). num(373). num(374). num(375).
num(376). num(377). num(378). num(379). num(380). num(381). num(382). num(383). num(384). num(385). num(386). num(387). num(388). num(389). num(390).
num(391). num(392). num(393). num(394). num(395). num(396). num(397). num(398). num(399). num(400). num(401). num(402). num(403). num(404). num(405).
num(406). num(407). num(408). num(409). num(410). num(411). num(412). num(413). num(414). num(415). num(416). num(417). num(418). num(419). num(420).
num(421). num(422). num(423). num(424). num(425). num(426). num(427). num(428). num(429). num(430). num(431). num(432). num(433). num(434). num(435).
num(436). num(437). num(438). num(439). num(440). num(441). num(442). num(443). num(444). num(445). num(446). num(447). num(448). num(449). num(450).
num(451). num(452). num(453). num(454). num(455). num(456). num(457). num(458). num(459). num(460). num(461). num(462). num(463). num(464). num(465).
num(466). num(467). num(468). num(469). num(470). num(471). num(472). num(473). num(474). num(475). num(476). num(477). num(478). num(479). num(480).
num(481). num(482). num(483). num(484). num(485). num(486). num(487). num(488). num(489). num(490). num(491). num(492). num(493). num(494). num(495).
num(496). num(497). num(498). num(499). num(500). num(501). num(502). num(503). num(504). num(505). num(506). num(507). num(508). num(509). num(510).
num(511). num(512). num(513). num(514). num(515). num(516). num(517). num(518). num(519). num(520). num(521). num(522). num(523). num(524). num(525).
num(526). num(527). num(528). num(529). num(530). num(531). num(532). num(533). num(534). num(535). num(536). num(537). num(538). num(539). num(540).
num(541). num(542). num(543). num(544). num(545). num(546). num(547). num(548). num(549). num(550). num(551). num(552). num(553). num(554). num(555).
num(556). num(557). num(558). num(559). num(560). num(561). num(562). num(563). num(564). num(565). num(566). num(567). num(568). num(569). num(570).
num(571). num(572). num(573). num(574). num(575). num(576). num(577). num(578). num(579). num(580). num(581). num(582). num(583). num(584). num(585).
num(586). num(587). num(588). num(589). num(590). num(591). num(592). num(593). num(594). num(595). num(596). num(597). num(598). num(599). num(600).
num(601). num(602). num(603). num(604). num(605). num(606). num(607). num(608). num(609). num(610). num(611). num(612). num(613). num(614). num(615).
num(616). num(617). num(618). num(619). num(620). num(621). num(622). num(623). num(624). num(625). num(626). num(627). num(628). num(629). num(630).
num(631). num(632). num(633). num(634). num(635). num(636). num(637). num(638). num(639). num(640). num(641). num(642). num(643). num(644). num(645).
num(646). num(647). num(648). num(649). num(650). num(651). num(652). num(653). num(654). num(655). num(656). num(657). num(658). num(659). num(660).
num(661). num(662). num(663). num(664). num(665). num(666). num(667). num(668). num(669). num(670). num(671). num(672). num(673). num(674). num(675).
num(676). num(677). num(678). num(679). num(680). num(681). num(682). num(683). num(684). num(685). num(686). num(687). num(688). num(689). num(690).
num(691). num(692). num(693). num(694). num(695). num(696). num(697). num(698). num(699). num(700). num(701). num(702). num(703). num(704). num(705).
num(706). num(707). num(708). num(709). num(710). num(711). num(712). num(713). num(714). num(715). num(716). num(717). num(718). num(719). num(720).
num(721). num(722). num(723). num(724). num(725). num(726). num(727). num(728). num(729). num(730). num(731). num(732). num(733). num(734). num(735).
num(736). num(737). num(738). num(739). num(740). num(741). num(742). num(743). num(744). num(745). num(746). num(747). num(748). num(749). num(750).
num(751). num(752). num(753). num(754). num(755). num(756). num(757). num(758). num(759). num(760). num(761). num(762). num(763). num(764). num(765).
num(766). num(767). num(768). num(769). num(770). num(771). num(772). num(773). num(774). num(775). num(776). num(777). num(778). num(779). num(780).
num(781). num(782). num(783). num(784). num(785). num(786). num(787). num(788). num(789). num(790). num(791). num(792). num(793). num(794). num(795).
num(796). num(797). num(798). num(799). num(800). num(801). num(802). num(803). num(804). num(805). num(806). num(807). num(808). num(809). num(810).
num(811). num(812). num(813). num(814). num(815). num(816). num(817). num(818). num(819). num(820). num(821). num(822). num(823). num(824). num(825).
num(826). num(827). num(828). num(829). num(830). num(831). num(832). num(833). num(834). num(835). num(836). num(837). num(838). num(839). num(840).
num(841). num(842). num(843). num(844). num(845). num(846). num(847). num(848). num(849). num(850). num(851). num(852). num(853). num(854). num(855).
num(856). num(857). num(858). num(859). num(860). num(861). num(862). num(863). num(864). num(865). num(866). num(867). num(868). num(869). num(870).
num(871). num(872). num(873). num(874). num(875). num(876). num(877). num(878). num(879). num(880). num(881). num(882). num(883). num(884). num(885).
num(886). num(887). num(888). num(889). num(890). num(891). num(892). num(893). num(894). num(895). num(896). num(897). num(898). num(899). num(900).
num(901). num(902). num(903). num(904). num(905). num(906). num(907). num(908). num(909). num(910). num(911). num(912). num(913). num(914). num(915).
num(916). num(917). num(918). num(919). num(920). num(921). num(922). num(923). num(924). num(925). num(926). num(927). num(928). num(929). num(930).
num(931). num(932). num(933). num(934). num(935). num(936). num(937). num(938). num(939). num(940). num(941). num(942). num(943). num(944). num(945).
num(946). num(947). num(948). num(949). num(950). num(951). num(952). num(953). num(954). num(955). num(956). num(957). num(958). num(959). num(960).
num(961). num(962). num(963). num(964). num(965). num(966). num(967). num(968). num(969). num(970). num(971). num(972). num(973). num(974). num(975).
num(976). num(977). num(978). num(979). num(980). num(981). num(982). num(983). num(984). num(985). num(986). num(987). num(988). num(989). num(990).
num(991). num(992). num(993). num(994). num(995). num(996). num(997). num(998). num(999). num(1000). 

%% --- Precomputed: ln(N) as integer (floor) ---
ln_floor(1,1). ln_floor(2,1). ln_floor(3,1). ln_floor(4,1). ln_floor(5,1). ln_floor(6,1). ln_floor(7,1). ln_floor(8,2). ln_floor(9,2). ln_floor(10,2). 
ln_floor(11,2). ln_floor(12,2). ln_floor(13,2). ln_floor(14,2). ln_floor(15,2). ln_floor(16,2). ln_floor(17,2). ln_floor(18,2). ln_floor(19,2). ln_floor(20,2). 
ln_floor(21,3). ln_floor(22,3). ln_floor(23,3). ln_floor(24,3). ln_floor(25,3). ln_floor(26,3). ln_floor(27,3). ln_floor(28,3). ln_floor(29,3). ln_floor(30,3). 
ln_floor(31,3). ln_floor(32,3). ln_floor(33,3). ln_floor(34,3). ln_floor(35,3). ln_floor(36,3). ln_floor(37,3). ln_floor(38,3). ln_floor(39,3). ln_floor(40,3). 
ln_floor(41,3). ln_floor(42,3). ln_floor(43,3). ln_floor(44,3). ln_floor(45,3). ln_floor(46,3). ln_floor(47,3). ln_floor(48,3). ln_floor(49,3). 

%% --- Precomputed: ceil(ln(N)) ---
ln_ceil(1,1). ln_ceil(2,1). ln_ceil(3,2). ln_ceil(4,2). ln_ceil(5,2). ln_ceil(6,2). ln_ceil(7,2). ln_ceil(8,3). ln_ceil(9,3). ln_ceil(10,3). 
ln_ceil(11,3). ln_ceil(12,3). ln_ceil(13,3). ln_ceil(14,3). ln_ceil(15,3). ln_ceil(16,3). ln_ceil(17,3). ln_ceil(18,3). ln_ceil(19,3). ln_ceil(20,3). 
ln_ceil(21,4). ln_ceil(22,4). ln_ceil(23,4). ln_ceil(24,4). ln_ceil(25,4). ln_ceil(26,4). ln_ceil(27,4). ln_ceil(28,4). ln_ceil(29,4). ln_ceil(30,4). 
ln_ceil(31,4). ln_ceil(32,4). ln_ceil(33,4). ln_ceil(34,4). ln_ceil(35,4). ln_ceil(36,4). ln_ceil(37,4). ln_ceil(38,4). ln_ceil(39,4). ln_ceil(40,4). 
ln_ceil(41,4). ln_ceil(42,4). ln_ceil(43,4). ln_ceil(44,4). ln_ceil(45,4). ln_ceil(46,4). ln_ceil(47,4). ln_ceil(48,4). ln_ceil(49,4). 

%% --- Precomputed: N * ln(N) rounded ---
n_ln_n(1,1). n_ln_n(2,1). n_ln_n(3,3). n_ln_n(4,6). n_ln_n(5,8). n_ln_n(6,11). n_ln_n(7,14). n_ln_n(8,17). n_ln_n(9,20). n_ln_n(10,23). 
n_ln_n(11,26). n_ln_n(12,30). n_ln_n(13,33). n_ln_n(14,37). n_ln_n(15,41). n_ln_n(16,44). n_ln_n(17,48). n_ln_n(18,52). n_ln_n(19,56). n_ln_n(20,60). 
n_ln_n(21,64). n_ln_n(22,68). n_ln_n(23,72). n_ln_n(24,76). n_ln_n(25,80). n_ln_n(26,85). n_ln_n(27,89). n_ln_n(28,93). n_ln_n(29,98). n_ln_n(30,102). 
n_ln_n(31,106). n_ln_n(32,111). n_ln_n(33,115). n_ln_n(34,120). n_ln_n(35,124). n_ln_n(36,129). n_ln_n(37,134). n_ln_n(38,138). n_ln_n(39,143). n_ln_n(40,148). 
n_ln_n(41,152). n_ln_n(42,157). n_ln_n(43,162). n_ln_n(44,167). n_ln_n(45,171). n_ln_n(46,176). n_ln_n(47,181). n_ln_n(48,186). n_ln_n(49,191). 

%% --- Precomputed: N*ln(N) + N*ln(ln(N)) rounded (better approx) ---
n_ln_n_ln_ln_n(2,2). n_ln_n_ln_ln_n(3,4). n_ln_n_ln_ln_n(4,7). n_ln_n_ln_ln_n(5,10). n_ln_n_ln_ln_n(6,14). n_ln_n_ln_ln_n(7,18). n_ln_n_ln_ln_n(8,22). n_ln_n_ln_ln_n(9,27). n_ln_n_ln_ln_n(10,31). 
n_ln_n_ln_ln_n(11,36). n_ln_n_ln_ln_n(12,41). n_ln_n_ln_ln_n(13,46). n_ln_n_ln_ln_n(14,51). n_ln_n_ln_ln_n(15,56). n_ln_n_ln_ln_n(16,61). n_ln_n_ln_ln_n(17,66). n_ln_n_ln_ln_n(18,71). n_ln_n_ln_ln_n(19,76). n_ln_n_ln_ln_n(20,82). 
n_ln_n_ln_ln_n(21,87). n_ln_n_ln_ln_n(22,93). n_ln_n_ln_ln_n(23,98). n_ln_n_ln_ln_n(24,104). n_ln_n_ln_ln_n(25,110). n_ln_n_ln_ln_n(26,115). n_ln_n_ln_ln_n(27,121). n_ln_n_ln_ln_n(28,127). n_ln_n_ln_ln_n(29,133). n_ln_n_ln_ln_n(30,139). 
n_ln_n_ln_ln_n(31,145). n_ln_n_ln_ln_n(32,151). n_ln_n_ln_ln_n(33,157). n_ln_n_ln_ln_n(34,163). n_ln_n_ln_ln_n(35,169). n_ln_n_ln_ln_n(36,175). n_ln_n_ln_ln_n(37,181). n_ln_n_ln_ln_n(38,187). n_ln_n_ln_ln_n(39,194). n_ln_n_ln_ln_n(40,200). 
n_ln_n_ln_ln_n(41,206). n_ln_n_ln_ln_n(42,212). n_ln_n_ln_ln_n(43,219). n_ln_n_ln_ln_n(44,225). n_ln_n_ln_ln_n(45,231). n_ln_n_ln_ln_n(46,238). n_ln_n_ln_ln_n(47,244). n_ln_n_ln_ln_n(48,251). n_ln_n_ln_ln_n(49,257). 

%% --- Precomputed: Cipolla approximation rounded ---
cipolla(3,2). cipolla(4,2). cipolla(5,2). cipolla(6,4). cipolla(7,6). cipolla(8,10). cipolla(9,13). cipolla(10,16). 
cipolla(11,20). cipolla(12,23). cipolla(13,27). cipolla(14,31). cipolla(15,35). cipolla(16,39). cipolla(17,43). cipolla(18,47). cipolla(19,52). cipolla(20,56). 
cipolla(21,60). cipolla(22,65). cipolla(23,69). cipolla(24,74). cipolla(25,78). cipolla(26,83). cipolla(27,88). cipolla(28,92). cipolla(29,97). cipolla(30,102). 
cipolla(31,107). cipolla(32,112). cipolla(33,117). cipolla(34,122). cipolla(35,127). cipolla(36,132). cipolla(37,137). cipolla(38,142). cipolla(39,147). cipolla(40,152). 
cipolla(41,157). cipolla(42,163). cipolla(43,168). cipolla(44,173). cipolla(45,179). cipolla(46,184). cipolla(47,189). cipolla(48,195). cipolla(49,200). 

%% --- Successor ---
succ(1,2). succ(2,3). succ(3,4). succ(4,5). succ(5,6). succ(6,7). succ(7,8). succ(8,9). succ(9,10). succ(10,11).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16). succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(21,22). succ(22,23). succ(23,24). succ(24,25). succ(25,26). succ(26,27). succ(27,28). succ(28,29). succ(29,30). succ(30,31).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36). succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46). succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(51,52). succ(52,53). succ(53,54). succ(54,55). succ(55,56). succ(56,57). succ(57,58). succ(58,59). succ(59,60). succ(60,61).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66). succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76). succ(76,77). succ(77,78). succ(78,79). succ(79,80). succ(80,81).
succ(81,82). succ(82,83). succ(83,84). succ(84,85). succ(85,86). succ(86,87). succ(87,88). succ(88,89). succ(89,90). succ(90,91).
succ(91,92). succ(92,93). succ(93,94). succ(94,95). succ(95,96). succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106). succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(111,112). succ(112,113). succ(113,114). succ(114,115). succ(115,116). succ(116,117). succ(117,118). succ(118,119). succ(119,120). succ(120,121).
succ(121,122). succ(122,123). succ(123,124). succ(124,125). succ(125,126). succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136). succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(141,142). succ(142,143). succ(143,144). succ(144,145). succ(145,146). succ(146,147). succ(147,148). succ(148,149). succ(149,150). succ(150,151).
succ(151,152). succ(152,153). succ(153,154). succ(154,155). succ(155,156). succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(161,162). succ(162,163). succ(163,164). succ(164,165). succ(165,166). succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(171,172). succ(172,173). succ(173,174). succ(174,175). succ(175,176). succ(176,177). succ(177,178). succ(178,179). succ(179,180). succ(180,181).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186). succ(186,187). succ(187,188). succ(188,189). succ(189,190). succ(190,191).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196). succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(201,202). succ(202,203). succ(203,204). succ(204,205). succ(205,206). succ(206,207). succ(207,208). succ(208,209). succ(209,210). succ(210,211).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216). succ(216,217). succ(217,218). succ(218,219). succ(219,220). succ(220,221).
succ(221,222). succ(222,223). succ(223,224). succ(224,225). succ(225,226). succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(231,232). succ(232,233). succ(233,234). succ(234,235). succ(235,236). succ(236,237). succ(237,238). succ(238,239). succ(239,240). succ(240,241).
succ(241,242). succ(242,243). succ(243,244). succ(244,245). succ(245,246). succ(246,247). succ(247,248). succ(248,249). succ(249,250). succ(250,251).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256). succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(261,262). succ(262,263). succ(263,264). succ(264,265). succ(265,266). succ(266,267). succ(267,268). succ(268,269). succ(269,270). succ(270,271).
succ(271,272). succ(272,273). succ(273,274). succ(274,275). succ(275,276). succ(276,277). succ(277,278). succ(278,279). succ(279,280). succ(280,281).
succ(281,282). succ(282,283). succ(283,284). succ(284,285). succ(285,286). succ(286,287). succ(287,288). succ(288,289). succ(289,290). succ(290,291).
succ(291,292). succ(292,293). succ(293,294). succ(294,295). succ(295,296). succ(296,297). succ(297,298). succ(298,299). succ(299,300). succ(300,301).
succ(301,302). succ(302,303). succ(303,304). succ(304,305). succ(305,306). succ(306,307). succ(307,308). succ(308,309). succ(309,310). succ(310,311).
succ(311,312). succ(312,313). succ(313,314). succ(314,315). succ(315,316). succ(316,317). succ(317,318). succ(318,319). succ(319,320). succ(320,321).
succ(321,322). succ(322,323). succ(323,324). succ(324,325). succ(325,326). succ(326,327). succ(327,328). succ(328,329). succ(329,330). succ(330,331).
succ(331,332). succ(332,333). succ(333,334). succ(334,335). succ(335,336). succ(336,337). succ(337,338). succ(338,339). succ(339,340). succ(340,341).
succ(341,342). succ(342,343). succ(343,344). succ(344,345). succ(345,346). succ(346,347). succ(347,348). succ(348,349). succ(349,350). succ(350,351).
succ(351,352). succ(352,353). succ(353,354). succ(354,355). succ(355,356). succ(356,357). succ(357,358). succ(358,359). succ(359,360). succ(360,361).
succ(361,362). succ(362,363). succ(363,364). succ(364,365). succ(365,366). succ(366,367). succ(367,368). succ(368,369). succ(369,370). succ(370,371).
succ(371,372). succ(372,373). succ(373,374). succ(374,375). succ(375,376). succ(376,377). succ(377,378). succ(378,379). succ(379,380). succ(380,381).
succ(381,382). succ(382,383). succ(383,384). succ(384,385). succ(385,386). succ(386,387). succ(387,388). succ(388,389). succ(389,390). succ(390,391).
succ(391,392). succ(392,393). succ(393,394). succ(394,395). succ(395,396). succ(396,397). succ(397,398). succ(398,399). succ(399,400). succ(400,401).
succ(401,402). succ(402,403). succ(403,404). succ(404,405). succ(405,406). succ(406,407). succ(407,408). succ(408,409). succ(409,410). succ(410,411).
succ(411,412). succ(412,413). succ(413,414). succ(414,415). succ(415,416). succ(416,417). succ(417,418). succ(418,419). succ(419,420). succ(420,421).
succ(421,422). succ(422,423). succ(423,424). succ(424,425). succ(425,426). succ(426,427). succ(427,428). succ(428,429). succ(429,430). succ(430,431).
succ(431,432). succ(432,433). succ(433,434). succ(434,435). succ(435,436). succ(436,437). succ(437,438). succ(438,439). succ(439,440). succ(440,441).
succ(441,442). succ(442,443). succ(443,444). succ(444,445). succ(445,446). succ(446,447). succ(447,448). succ(448,449). succ(449,450). succ(450,451).
succ(451,452). succ(452,453). succ(453,454). succ(454,455). succ(455,456). succ(456,457). succ(457,458). succ(458,459). succ(459,460). succ(460,461).
succ(461,462). succ(462,463). succ(463,464). succ(464,465). succ(465,466). succ(466,467). succ(467,468). succ(468,469). succ(469,470). succ(470,471).
succ(471,472). succ(472,473). succ(473,474). succ(474,475). succ(475,476). succ(476,477). succ(477,478). succ(478,479). succ(479,480). succ(480,481).
succ(481,482). succ(482,483). succ(483,484). succ(484,485). succ(485,486). succ(486,487). succ(487,488). succ(488,489). succ(489,490). succ(490,491).
succ(491,492). succ(492,493). succ(493,494). succ(494,495). succ(495,496). succ(496,497). succ(497,498). succ(498,499). succ(499,500). succ(500,501).
succ(501,502). succ(502,503). succ(503,504). succ(504,505). succ(505,506). succ(506,507). succ(507,508). succ(508,509). succ(509,510). succ(510,511).
succ(511,512). succ(512,513). succ(513,514). succ(514,515). succ(515,516). succ(516,517). succ(517,518). succ(518,519). succ(519,520). succ(520,521).
succ(521,522). succ(522,523). succ(523,524). succ(524,525). succ(525,526). succ(526,527). succ(527,528). succ(528,529). succ(529,530). succ(530,531).
succ(531,532). succ(532,533). succ(533,534). succ(534,535). succ(535,536). succ(536,537). succ(537,538). succ(538,539). succ(539,540). succ(540,541).
succ(541,542). succ(542,543). succ(543,544). succ(544,545). succ(545,546). succ(546,547). succ(547,548). succ(548,549). succ(549,550). succ(550,551).
succ(551,552). succ(552,553). succ(553,554). succ(554,555). succ(555,556). succ(556,557). succ(557,558). succ(558,559). succ(559,560). succ(560,561).
succ(561,562). succ(562,563). succ(563,564). succ(564,565). succ(565,566). succ(566,567). succ(567,568). succ(568,569). succ(569,570). succ(570,571).
succ(571,572). succ(572,573). succ(573,574). succ(574,575). succ(575,576). succ(576,577). succ(577,578). succ(578,579). succ(579,580). succ(580,581).
succ(581,582). succ(582,583). succ(583,584). succ(584,585). succ(585,586). succ(586,587). succ(587,588). succ(588,589). succ(589,590). succ(590,591).
succ(591,592). succ(592,593). succ(593,594). succ(594,595). succ(595,596). succ(596,597). succ(597,598). succ(598,599). succ(599,600). succ(600,601).
succ(601,602). succ(602,603). succ(603,604). succ(604,605). succ(605,606). succ(606,607). succ(607,608). succ(608,609). succ(609,610). succ(610,611).
succ(611,612). succ(612,613). succ(613,614). succ(614,615). succ(615,616). succ(616,617). succ(617,618). succ(618,619). succ(619,620). succ(620,621).
succ(621,622). succ(622,623). succ(623,624). succ(624,625). succ(625,626). succ(626,627). succ(627,628). succ(628,629). succ(629,630). succ(630,631).
succ(631,632). succ(632,633). succ(633,634). succ(634,635). succ(635,636). succ(636,637). succ(637,638). succ(638,639). succ(639,640). succ(640,641).
succ(641,642). succ(642,643). succ(643,644). succ(644,645). succ(645,646). succ(646,647). succ(647,648). succ(648,649). succ(649,650). succ(650,651).
succ(651,652). succ(652,653). succ(653,654). succ(654,655). succ(655,656). succ(656,657). succ(657,658). succ(658,659). succ(659,660). succ(660,661).
succ(661,662). succ(662,663). succ(663,664). succ(664,665). succ(665,666). succ(666,667). succ(667,668). succ(668,669). succ(669,670). succ(670,671).
succ(671,672). succ(672,673). succ(673,674). succ(674,675). succ(675,676). succ(676,677). succ(677,678). succ(678,679). succ(679,680). succ(680,681).
succ(681,682). succ(682,683). succ(683,684). succ(684,685). succ(685,686). succ(686,687). succ(687,688). succ(688,689). succ(689,690). succ(690,691).
succ(691,692). succ(692,693). succ(693,694). succ(694,695). succ(695,696). succ(696,697). succ(697,698). succ(698,699). succ(699,700). succ(700,701).
succ(701,702). succ(702,703). succ(703,704). succ(704,705). succ(705,706). succ(706,707). succ(707,708). succ(708,709). succ(709,710). succ(710,711).
succ(711,712). succ(712,713). succ(713,714). succ(714,715). succ(715,716). succ(716,717). succ(717,718). succ(718,719). succ(719,720). succ(720,721).
succ(721,722). succ(722,723). succ(723,724). succ(724,725). succ(725,726). succ(726,727). succ(727,728). succ(728,729). succ(729,730). succ(730,731).
succ(731,732). succ(732,733). succ(733,734). succ(734,735). succ(735,736). succ(736,737). succ(737,738). succ(738,739). succ(739,740). succ(740,741).
succ(741,742). succ(742,743). succ(743,744). succ(744,745). succ(745,746). succ(746,747). succ(747,748). succ(748,749). succ(749,750). succ(750,751).
succ(751,752). succ(752,753). succ(753,754). succ(754,755). succ(755,756). succ(756,757). succ(757,758). succ(758,759). succ(759,760). succ(760,761).
succ(761,762). succ(762,763). succ(763,764). succ(764,765). succ(765,766). succ(766,767). succ(767,768). succ(768,769). succ(769,770). succ(770,771).
succ(771,772). succ(772,773). succ(773,774). succ(774,775). succ(775,776). succ(776,777). succ(777,778). succ(778,779). succ(779,780). succ(780,781).
succ(781,782). succ(782,783). succ(783,784). succ(784,785). succ(785,786). succ(786,787). succ(787,788). succ(788,789). succ(789,790). succ(790,791).
succ(791,792). succ(792,793). succ(793,794). succ(794,795). succ(795,796). succ(796,797). succ(797,798). succ(798,799). succ(799,800). succ(800,801).
succ(801,802). succ(802,803). succ(803,804). succ(804,805). succ(805,806). succ(806,807). succ(807,808). succ(808,809). succ(809,810). succ(810,811).
succ(811,812). succ(812,813). succ(813,814). succ(814,815). succ(815,816). succ(816,817). succ(817,818). succ(818,819). succ(819,820). succ(820,821).
succ(821,822). succ(822,823). succ(823,824). succ(824,825). succ(825,826). succ(826,827). succ(827,828). succ(828,829). succ(829,830). succ(830,831).
succ(831,832). succ(832,833). succ(833,834). succ(834,835). succ(835,836). succ(836,837). succ(837,838). succ(838,839). succ(839,840). succ(840,841).
succ(841,842). succ(842,843). succ(843,844). succ(844,845). succ(845,846). succ(846,847). succ(847,848). succ(848,849). succ(849,850). succ(850,851).
succ(851,852). succ(852,853). succ(853,854). succ(854,855). succ(855,856). succ(856,857). succ(857,858). succ(858,859). succ(859,860). succ(860,861).
succ(861,862). succ(862,863). succ(863,864). succ(864,865). succ(865,866). succ(866,867). succ(867,868). succ(868,869). succ(869,870). succ(870,871).
succ(871,872). succ(872,873). succ(873,874). succ(874,875). succ(875,876). succ(876,877). succ(877,878). succ(878,879). succ(879,880). succ(880,881).
succ(881,882). succ(882,883). succ(883,884). succ(884,885). succ(885,886). succ(886,887). succ(887,888). succ(888,889). succ(889,890). succ(890,891).
succ(891,892). succ(892,893). succ(893,894). succ(894,895). succ(895,896). succ(896,897). succ(897,898). succ(898,899). succ(899,900). succ(900,901).
succ(901,902). succ(902,903). succ(903,904). succ(904,905). succ(905,906). succ(906,907). succ(907,908). succ(908,909). succ(909,910). succ(910,911).
succ(911,912). succ(912,913). succ(913,914). succ(914,915). succ(915,916). succ(916,917). succ(917,918). succ(918,919). succ(919,920). succ(920,921).
succ(921,922). succ(922,923). succ(923,924). succ(924,925). succ(925,926). succ(926,927). succ(927,928). succ(928,929). succ(929,930). succ(930,931).
succ(931,932). succ(932,933). succ(933,934). succ(934,935). succ(935,936). succ(936,937). succ(937,938). succ(938,939). succ(939,940). succ(940,941).
succ(941,942). succ(942,943). succ(943,944). succ(944,945). succ(945,946). succ(946,947). succ(947,948). succ(948,949). succ(949,950). succ(950,951).
succ(951,952). succ(952,953). succ(953,954). succ(954,955). succ(955,956). succ(956,957). succ(957,958). succ(958,959). succ(959,960). succ(960,961).
succ(961,962). succ(962,963). succ(963,964). succ(964,965). succ(965,966). succ(966,967). succ(967,968). succ(968,969). succ(969,970). succ(970,971).
succ(971,972). succ(972,973). succ(973,974). succ(974,975). succ(975,976). succ(976,977). succ(977,978). succ(978,979). succ(979,980). succ(980,981).
succ(981,982). succ(982,983). succ(983,984). succ(984,985). succ(985,986). succ(986,987). succ(987,988). succ(988,989). succ(989,990). succ(990,991).
succ(991,992). succ(992,993). succ(993,994). succ(994,995). succ(995,996). succ(996,997). succ(997,998). succ(998,999). succ(999,1000). 

%% --- Basic Arithmetic (computed) ---
add(X, Y, Z) :- num(X), num(Y), Z is X + Y, num(Z).
sub(X, Y, Z) :- num(X), num(Y), Z is X - Y, Z > 0, num(Z).
mult(X, Y, Z) :- num(X), num(Y), X > 0, Y > 0, Z is X * Y, num(Z).
int_div(X, Y, Z) :- num(X), num(Y), Y > 0, Z is X // Y, Z > 0, num(Z).
modulo(X, Y, Z) :- num(X), num(Y), Y > 0, Z is X mod Y.

%% --- Multiply by constants ---
double(X, Y) :- num(X), Y is 2 * X, num(Y).
triple(X, Y) :- num(X), Y is 3 * X, num(Y).

%% --- Powers ---
square(X, Y) :- num(X), X > 0, Y is X * X, num(Y).

%% --- Increment/Decrement ---
inc(X, Y) :- num(X), Y is X + 1, num(Y).
dec(X, Y) :- num(X), X > 1, Y is X - 1, num(Y).

%% --- Comparison ---
greater_than(X, Y) :- num(X), num(Y), X > Y.
less_than(X, Y) :- num(X), num(Y), X < Y.

%% --- Constants ---
one(1).
two(2).
three(3).
six(6).
