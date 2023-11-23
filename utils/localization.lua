--| Based on the current locales supported by Roblox (although not fully for some of them)

local localization = {}

local localeInfo = {
	[1] = {
		["locale"] = {
			["locale"] = "bs_ba",
			["name"] = "Bosnian",
			["id"] = 43,
			["language"] = {
				["name"] = "Bosnian",
				["isRightToLeft"] = false,
				["id"] = 22,
				["languageCode"] = "bs",
				["nativeName"] = "bosanski jezik"
			},
			["nativeName"] = "Босански"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[2] = {
		["locale"] = {
			["locale"] = "nl_nl",
			["name"] = "Dutch",
			["id"] = 34,
			["language"] = {
				["name"] = "Dutch",
				["isRightToLeft"] = false,
				["id"] = 39,
				["languageCode"] = "nl",
				["nativeName"] = "Nederlands"
			},
			["nativeName"] = "Nederlands"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[3] = {
		["locale"] = {
			["locale"] = "nb_no",
			["name"] = "Bokmal",
			["id"] = 33,
			["language"] = {
				["name"] = "Bokmal",
				["isRightToLeft"] = false,
				["id"] = 113,
				["languageCode"] = "nb",
				["nativeName"] = "Norsk Bokmål"
			},
			["nativeName"] = "Bokmål"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[4] = {
		["locale"] = {
			["locale"] = "el_gr",
			["name"] = "Greek",
			["id"] = 20,
			["language"] = {
				["name"] = "Greek",
				["isRightToLeft"] = false,
				["id"] = 53,
				["languageCode"] = "el",
				["nativeName"] = "ελληνικά"
			},
			["nativeName"] = "Ελληνικά"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[5] = {
		["locale"] = {
			["locale"] = "bg_bg",
			["name"] = "Bulgarian",
			["id"] = 16,
			["language"] = {
				["name"] = "Bulgarian",
				["isRightToLeft"] = false,
				["id"] = 24,
				["languageCode"] = "bg",
				["nativeName"] = "български език"
			},
			["nativeName"] = "Български"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[6] = {
		["locale"] = {
			["locale"] = "pl_pl",
			["name"] = "Polish",
			["id"] = 36,
			["language"] = {
				["name"] = "Polish",
				["isRightToLeft"] = false,
				["id"] = 126,
				["languageCode"] = "pl",
				["nativeName"] = "Język Polski"
			},
			["nativeName"] = "Polski"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[7] = {
		["locale"] = {
			["locale"] = "ru_ru",
			["name"] = "Russian",
			["id"] = 8,
			["language"] = {
				["name"] = "Russian",
				["isRightToLeft"] = false,
				["id"] = 133,
				["languageCode"] = "ru",
				["nativeName"] = "Русский"
			},
			["nativeName"] = "Русский"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[8] = {
		["locale"] = {
			["locale"] = "lv_lv",
			["name"] = "Latvian",
			["id"] = 30,
			["language"] = {
				["name"] = "Latvian",
				["isRightToLeft"] = false,
				["id"] = 97,
				["languageCode"] = "lv",
				["nativeName"] = "Latviešu Valoda"
			},
			["nativeName"] = "Latviešu"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[9] = {
		["locale"] = {
			["locale"] = "zh_cn",
			["name"] = "Chinese (Simplified)",
			["id"] = 14,
			["language"] = {
				["name"] = "Chinese (Simplified)",
				["isRightToLeft"] = false,
				["id"] = 30,
				["languageCode"] = "zh-hans",
				["nativeName"] = "简体中文"
			},
			["nativeName"] = "中文(简体)"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[10] = {
		["locale"] = {
			["locale"] = "zh_tw",
			["name"] = "Chinese (Traditional)",
			["id"] = 15,
			["language"] = {
				["name"] = "Chinese (Traditional)",
				["isRightToLeft"] = false,
				["id"] = 189,
				["languageCode"] = "zh-hant",
				["nativeName"] = "繁體中文"
			},
			["nativeName"] = "中文(繁體)"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[11] = {
		["locale"] = {
			["locale"] = "hr_hr",
			["name"] = "Croatian",
			["id"] = 24,
			["language"] = {
				["name"] = "Croatian",
				["isRightToLeft"] = false,
				["id"] = 35,
				["languageCode"] = "hr",
				["nativeName"] = "hrvatski jezik"
			},
			["nativeName"] = "Hrvatski"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[12] = {
		["locale"] = {
			["locale"] = "lt_lt",
			["name"] = "Lithuanian",
			["id"] = 29,
			["language"] = {
				["name"] = "Lithuanian",
				["isRightToLeft"] = false,
				["id"] = 95,
				["languageCode"] = "lt",
				["nativeName"] = "lietuvių kalba"
			},
			["nativeName"] = "Lietuvių"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[13] = {
		["locale"] = {
			["locale"] = "tr_tr",
			["name"] = "Turkish",
			["id"] = 10,
			["language"] = {
				["name"] = "Turkish",
				["isRightToLeft"] = false,
				["id"] = 163,
				["languageCode"] = "tr",
				["nativeName"] = "Türkçe"
			},
			["nativeName"] = "Türkçe"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[14] = {
		["locale"] = {
			["locale"] = "da_dk",
			["name"] = "Danish",
			["id"] = 19,
			["language"] = {
				["name"] = "Danish",
				["isRightToLeft"] = false,
				["id"] = 37,
				["languageCode"] = "da",
				["nativeName"] = "dansk"
			},
			["nativeName"] = "Dansk"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[15] = {
		["locale"] = {
			["locale"] = "cs_cz",
			["name"] = "Czech",
			["id"] = 18,
			["language"] = {
				["name"] = "Czech",
				["isRightToLeft"] = false,
				["id"] = 36,
				["languageCode"] = "cs",
				["nativeName"] = "čeština"
			},
			["nativeName"] = "Čeština"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[16] = {
		["locale"] = {
			["locale"] = "it_it",
			["name"] = "Italian",
			["id"] = 5,
			["language"] = {
				["name"] = "Italian",
				["isRightToLeft"] = false,
				["id"] = 71,
				["languageCode"] = "it",
				["nativeName"] = "Italiano"
			},
			["nativeName"] = "Italiano"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[17] = {
		["locale"] = {
			["locale"] = "es_es",
			["name"] = "Spanish(Spain)",
			["id"] = 2,
			["language"] = {
				["name"] = "Spanish",
				["isRightToLeft"] = false,
				["id"] = 148,
				["languageCode"] = "es",
				["nativeName"] = "Español"
			},
			["nativeName"] = "Español"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[18] = {
		["locale"] = {
			["locale"] = "kk_kz",
			["name"] = "Kazakh",
			["id"] = 27,
			["language"] = {
				["name"] = "Kazakh",
				["isRightToLeft"] = false,
				["id"] = 79,
				["languageCode"] = "kk",
				["nativeName"] = "қазақ тілі"
			},
			["nativeName"] = "Қазақ Тілі"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[19] = {
		["locale"] = {
			["locale"] = "fil_ph",
			["name"] = "Filipino",
			["id"] = 35,
			["language"] = {
				["name"] = "Filipino",
				["isRightToLeft"] = false,
				["id"] = 190,
				["languageCode"] = "fil",
				["nativeName"] = "Filipino"
			},
			["nativeName"] = "Filipino"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[20] = {
		["locale"] = {
			["locale"] = "ms_my",
			["name"] = "Malay",
			["id"] = 31,
			["language"] = {
				["name"] = "Malay",
				["isRightToLeft"] = false,
				["id"] = 101,
				["languageCode"] = "ms",
				["nativeName"] =" بهاس ملايو‎"
			},
			["nativeName"] = "Bahasa Melayu"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[21] = {
		["locale"] = {
			["locale"] = "sv_se",
			["name"] = "Swedish",
			["id"] = 45,
			["language"] = {
				["name"] = "Swedish",
				["isRightToLeft"] = false,
				["id"] = 152,
				["languageCode"] = "sv",
				["nativeName"] = "Svenska"
			},
			["nativeName"] = "Svenska"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[22] = {
		["locale"] = {
			["locale"] = "si_lk",
			["name"] = "Sinhala",
			["id"] = 39,
			["language"] = {
				["name"] = "Sinhala",
				["isRightToLeft"] = false,
				["id"] = 143,
				["languageCode"] = "si",
				["nativeName"] = "සිංහල"
			},
			["nativeName"] = "සිංහල"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[23] = {
		["locale"] = {
			["locale"] = "sq_al",
			["name"] = "Albanian",
			["id"] = 42,
			["language"] = {
				["name"] = "Albanian",
				["isRightToLeft"] = false,
				["id"] = 5,
				["languageCode"] = "sq",
				["nativeName"] = "Shqip"
			},
			["nativeName"] = "Shqipe"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[24] = {
		["locale"] = {
			["locale"] = "et_ee",
			["name"] = "Estonian",
			["id"] = 21,
			["language"] = {
				["name"] = "Estonian",
				["isRightToLeft"] = false,
				["id"] = 43,
				["languageCode"] = "et",
				["nativeName"] = "eesti, eesti keel"
			},
			["nativeName"] = "Eesti"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[25] = {
		["locale"] = {
			["locale"] = "sl_sl",
			["name"] = "Slovenian",
			["id"] = 41,
			["language"] = {
				["name"] = "Slovenian",
				["isRightToLeft"] = false,
				["id"] = 145,
				["languageCode"] = "sl",
				["nativeName"] = "Slovenščina"
			},
			["nativeName"] = "Slovenski"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[26] = {
		["locale"] = {
			["locale"] = "de_de",
			["name"] = "German",
			["id"] = 13,
			["language"] = {
				["name"] = "German",
				["isRightToLeft"] = false,
				["id"] = 52,
				["languageCode"] = "de",
				["nativeName"] = "Deutsch"
			},
			["nativeName"] = "Deutsch"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[27] = {
		["locale"] = {
			["locale"] = "km_kh",
			["name"] = "Khmer",
			["id"] = 28,
			["language"] = {
				["name"] = "Khmer",
				["isRightToLeft"] = false,
				["id"] = 188,
				["languageCode"] = "km",
				["nativeName"] = "ភាសាខ្មែរ"
			},
			["nativeName"] = "ភាសាខ្មែរ"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[28] = {
		["locale"] = {
			["locale"] = "uk_ua",
			["name"] = "Ukrainian",
			["id"] = 38,
			["language"] = {
				["name"] = "Ukrainian",
				["isRightToLeft"] = false,
				["id"] = 169,
				["languageCode"] = "uk",
				["nativeName"] = "Українська"
			},
			["nativeName"] = "Yкраїньска"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[29] = {
		["locale"] = {
			["locale"] = "vi_vn",
			["name"] = "Vietnamese",
			["id"] = 11,
			["language"] = {
				["name"] = "Vietnamese",
				["isRightToLeft"] = false,
				["id"] = 173,
				["languageCode"] = "vi",
				["nativeName"] = "Tiếng Việt"
			},
			["nativeName"] = "Tiếng Việt"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[30] = {
		["locale"] = {
			["locale"] = "my_mm",
			["name"] = "Burmese",
			["id"] = 32,
			["language"] = {
				["name"] = "Burmese",
				["isRightToLeft"] = false,
				["id"] = 25,
				["languageCode"] = "my",
				["nativeName"] = "ဗမာစာ"
			},
			["nativeName"] = "ဗမာစာ"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[31] = {
		["locale"] = {
			["locale"] = "ka_ge",
			["name"] = "Georgian",
			["id"] = 26,
			["language"] = {
				["name"] = "Georgian",
				["isRightToLeft"] = false,
				["id"] = 51,
				["languageCode"] = "ka",
				["nativeName"] = "ქართული"
			},
			["nativeName"] = "ქართული"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[32] = {
		["locale"] = {
			["locale"] = "id_id",
			["name"] = "Indonesian",
			["id"] = 4,
			["language"] = {
				["name"] = "Indonesian",
				["isRightToLeft"] = false,
				["id"] = 64,
				["languageCode"] = "id",
				["nativeName"] = "Bahasa Indonesia"
			},
			["nativeName"] = "Bahasa Indonesia"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[33] = {
		["locale"] = {
			["locale"] = "ar_001",
			["name"] = "Arabic",
			["id"] = 48,
			["language"] = {
				["name"] = "Arabic",
				["isRightToLeft"] = true,
				["id"] = 7,
				["languageCode"] = "ar",
				["nativeName"] = "العربية"
			},
			["nativeName"] = "العربية"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[34] = {
		["locale"] = {
			["locale"] = "fi_fi",
			["name"] = "Finnish",
			["id"] = 22,
			["language"] = {
				["name"] = "Finnish",
				["isRightToLeft"] = false,
				["id"] = 47,
				["languageCode"] = "fi",
				["nativeName"] = "suomi"
			},
			["nativeName"] = "Suomi"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[35] = {
		["locale"] = {
			["locale"] = "hi_in",
			["name"] = "Hindi",
			["id"] = 23,
			["language"] = {
				["name"] = "Hindi",
				["isRightToLeft"] = false,
				["id"] = 60,
				["languageCode"] = "hi",
				["nativeName"] = "हिन्दी, हिंदी"
			},
			["nativeName"] = "हिन्दी"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[36] = {
		["locale"] = {
			["locale"] = "ro_ro",
			["name"] = "Romanian",
			["id"] = 37,
			["language"] = {
				["name"] = "Romanian",
				["isRightToLeft"] = false,
				["id"] = 132,
				["languageCode"] = "ro",
				["nativeName"] = "Română"
			},
			["nativeName"] = "Română"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[37] = {
		["locale"] = {
			["locale"] = "en_us",
			["name"] = "English(US)",
			["id"] = 1,
			["language"] = {
				["name"] = "English",
				["isRightToLeft"] = false,
				["id"] = 41,
				["languageCode"] = "en",
				["nativeName"] = "English"
			},
			["nativeName"] = "English"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[38] = {
		["locale"] = {
			["locale"] = "fr_fr",
			["name"] = "French",
			["id"] = 3,
			["language"] = {
				["name"] = "French",
				["isRightToLeft"] = false,
				["id"] = 48,
				["languageCode"] = "fr",
				["nativeName"] = "Français"
			},
			["nativeName"] = "Français"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[39] = {
		["locale"] = {
			["locale"] = "hu_hu",
			["name"] = "Hungarian",
			["id"] = 25,
			["language"] = {
				["name"] = "Hungarian",
				["isRightToLeft"] = false,
				["id"] = 62,
				["languageCode"] = "hu",
				["nativeName"] = "magyar"
			},
			["nativeName"] = "Magyar"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[40] = {
		["locale"] = {
			["locale"] = "ko_kr",
			["name"] = "Korean",
			["id"] = 7,
			["language"] = {
				["name"] = "Korean",
				["isRightToLeft"] = false,
				["id"] = 86,
				["languageCode"] = "ko",
				["nativeName"] = "한국어"
			},
			["nativeName"] = "한국어"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[41] = {
		["locale"] = {
			["locale"] = "bn_bd",
			["name"] = "Bengali",
			["id"] = 17,
			["language"] = {
				["name"] = "Bengali",
				["isRightToLeft"] = false,
				["id"] = 19,
				["languageCode"] = "bn",
				["nativeName"] = "বাংলা"
			},
			["nativeName"] = "বাংলা"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[42] = {
		["locale"] = {
			["locale"] = "sr_rs",
			["name"] = "Serbian",
			["id"] = 44,
			["language"] = {
				["name"] = "Serbian",
				["isRightToLeft"] = false,
				["id"] = 140,
				["languageCode"] = "sr",
				["nativeName"] = "српски језик"
			},
			["nativeName"] = "Cрпски"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[43] = {
		["locale"] = {
			["locale"] = "sk_sk",
			["name"] = "Slovak",
			["id"] = 40,
			["language"] = {
				["name"] = "Slovak",
				["isRightToLeft"] = false,
				["id"] = 144,
				["languageCode"] = "sk",
				["nativeName"] = "Slovenčina"
			},
			["nativeName"] = "Slovenčina"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = false,
		["isEnabledForSignupAndLogin"] = false
	},
	[44] = {
		["locale"] = {
			["locale"] = "th_th",
			["name"] = "Thai",
			["id"] = 9,
			["language"] = {
				["name"] = "Thai",
				["isRightToLeft"] = false,
				["id"] = 156,
				["languageCode"] = "th",
				["nativeName"] = "ไทย"
			},
			["nativeName"] = "ภาษาไทย"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[45] = {
		["locale"] = {
			["locale"] = "pt_br",
			["name"] = "Portuguese (Brazil)",
			["id"] = 12,
			["language"] = {
				["name"] = "Portuguese",
				["isRightToLeft"] = false,
				["id"] = 128,
				["languageCode"] = "pt",
				["nativeName"] = "Português"
			},
			["nativeName"] = "Português (Brasil)"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	},
	[46] = {
		["locale"] = {
			["locale"] = "ja_jp",
			["name"] = "Japanese",
			["id"] = 6,
			["language"] = {
				["name"] = "Japanese",
				["isRightToLeft"] = false,
				["id"] = 73,
				["languageCode"] = "ja",
				["nativeName"] = "日本語 (にほんご)",
			},
			["nativeName"] = "日本語"
		},
		["isEnabledForInGameUgc"] = true,
		["isEnabledForFullExperience"] = true,
		["isEnabledForSignupAndLogin"] = true
	}
}

function localization:GetLocaleInfoFromLocaleId(id: string)
	for locale, info in localeInfo do
		if info["locale"]["locale"] == id then
			return info
		end
	end
	
	return nil
end

function localization:GetLocaleInfoFromLanguage(language: string)
	for locale, info in localeInfo do
		local name1, name2 = info["locale"]["name"], info["locale"]["language"]["name"]
		
		if string.match(name1, "^" .. language .. "$") or string.match(name2, "^" .. language .. "$") then
			return info
		end
	end
	
	return nil
end

function localization:GetLocaleInfoFromLanguageCode(code: string)
	for locale, info in localeInfo do
		if info["locale"]["language"]["languageCode"] == code then
			return info
		end
	end

	return nil
end

return localization
