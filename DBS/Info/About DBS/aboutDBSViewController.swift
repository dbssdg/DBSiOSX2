//
//  aboutDBSViewController.swift
//  DBS
//
//  Created by SDG on 18/10/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

class aboutDBSViewController: UIViewController {

    @IBOutlet weak var information: UITextView!
    
    @IBAction func onAboutDBSSettingsPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3){
            self.aboutDBSCollectionView.forEach {
                $0.isHidden = !$0.isHidden
            }
        }
    }
    
    @IBOutlet var aboutDBSCollectionView: [UIView]! {
        didSet {
            aboutDBSCollectionView.forEach {
                $0.isHidden = false
            }
        }
    }
    
    @IBAction func vAndM(_ sender: Any) {
        self.title = "Vision and Mission"
        information.scrollRangeToVisible(NSRange(location: 0, length: 0))
        information.attributedText = attributedText({"""
        Vision
        The vision of our school is to equip our students with the sound knowledge, worthy qualities, dynamic social and technical skills they need to become contributors to society and leaders with integrity in a diverse and ever-changing world.

        Mission
        \u{2022} The mission of the school is to provide a liberal education based on Christian principles.
        \u{2022} To realize this stated mission, the school has set the following objectives:
        \u{2022} To offer a well-balanced education for the development of the WHOLE person.
        \u{2022} To maintain well-established school traditions.
        \u{2022} To nurture a unique cultural identity.
        \u{2022} To achieve self-respect and self-esteem so that each student can be a man of integrity, discipline, devotion, industriousness, courage and gratitude.
        \u{2022} To promote multiple intelligence so that students can fully develop their talents.
        \u{2022} To equip our students to become life-long learners with a solid foundation of knowledge, essential qualities of good character and proper social and technical skills in order to achieve success in the future.
        """}(), ["Vision", "Mission"])
        hideButtons()
    }
    @IBAction func schoolPolicy(_ sender: Any) {
        self.title = "School Policy"
        information.scrollRangeToVisible(NSRange(location: 0, length: 0))
        information.attributedText = attributedText({"""
    Introduction
    The mission of Diocesan Boys' School stands as providing a liberal education based on Christian principles for the development of a whole person of good character, the acquisition of creative and critical thinking skills and the cultivation of multiple intelligence maximizing students' diverse talents. Our school policy reassures our prime concern of equipping students with sound knowledge, worthy personal qualities, dynamic social and technical skills to achieve success in this rapidly advancing pluralistic society.

    I. Quality Assurance
    The Diocesan Boys' School Committee Incorporation Ordinance (Cap. 1123 of the Laws of Hong Kong) enacted in 1969 gives the School Committee the full power ‘to manage, administer and operate the Diocesan Boys' School'. The School Committee focuses on setting school policies, the mission and vision, the raising, management and allocation of funds and managing a relationship with the Diocese, relevant Government departments and other educational institutes. The working group of the School Committee closely monitors the use of fundings as well as the implementation of the school policies. Members of the School Committee also sit on the School Management Committee and the Consultative Committee to ensure the smooth running of the school and a continuous exchange of views between teachers, parents and students.

    II. Curriculum and Assessment
    The recommended syllabuses specified by the Curriculum Development Institute form the backbone of the DBS curriculum. Starting from the school year 2009-2010, the new senior secondary curriculum is being adopted in all of the subsidized secondary schools as well as those under the Direct Subsidy scheme. Upon completing the final year of Secondary Six, students will take part in the first Hong Kong Diploma of Secondary Education Examinations in 2012.

    In addition, having received the final authorization from the International Baccalaureate Organization, our school will offer the International Baccalaureate Diploma Programme starting from the school year 2010-2011. This comprehensive and challenging two-year course widely recognized for its high academic standards is for Grade 11 and Grade 12 students with an aim of preparing them for university studies. Assessment is varied and takes place over two years with final examinations in each subject. Student's work is assessed by an international board of examiners who are rigorously trained and monitored by the International Baccalaureate Organization. Prior to the Diploma Programme, our school is offering the Bridging Programme for Grade 10 students starting from the school year 2009-2010. Its main focus is on the development of skills in preparing students to meet the requirement of the rigorous Diploma Programme.

    III. Teaching and Learning
    The school is to provide a well-balanced education for the development of a whole person through effective means and agreeable strategies. Teaching and learning under both the reformed local curriculum and the International Baccalaureate Diploma Programme aims to enable our students to excel their language and numerical abilities, to broaden their knowledge base and to possess capabilities of critical thinking, independent learning and interpersonal skills.
    It is of equal importance to meet the needs of individual students while facilitating a whole-person development. Equal emphasis is placed on academic abilities, language skills, information technology, physical education and music. Through participation in the clubs, societies, interest groups, student organizations and school teams, students experience growth in areas in addition to their academic studies. Local and overseas exchange and service programmes are encouraged to enrich common knowledge and deepen the understanding of our world outside the classroom setting. The Boarding School, a unique DBS feature, aims at further fostering a strong sense of responsibility and self-discipline among students.

    IV. The Medium of Instruction
    From the beginning, the school has had an extensive history of internationalism. Students other than those of a Chinese descent attended our school alongside their fellow Chinese schoolmates. The English language has traditionally been and will continue to be adopted as the medium of instruction in our classrooms. The Chinese language will remain as the medium of instruction in the Chinese Language and the Chinese History classes.
    To further equip our students for the multi-linguistic trend in the ever-advancing societies, our school has all along provided students the opportunity of learning French as a second language in place of Chinese. French will, therefore, be used in the teaching of the French Language. All the relevant teaching materials and resources will be in English, Chinese and French with respect to the circumstances specified above.
"""}(), ["Introduction", "I. Quality Assurance", "II. Curriculum and Assessment", "III. Teaching and Learning", "IV. The Medium of Instruction"])
        hideButtons()
    }
    @IBAction func history(_ sender: Any) {
        self.title = "A Brief History of DBS"
        information.scrollRangeToVisible(NSRange(location: 0, length: 0))
        information.attributedText = attributedText({"""
        Prologue
        The Diocesan Boys' School is of a humble origin, and has behind it a long record and a proud one. The School campus is such that any school anywhere may be proud of, be we know that the strength of a school lies, not in bricks, but in brains, in the all-round training it gives for life and in its power to develop character.
        The "First Foundation" of the school is referred to an earlier institution established by the Society for the Promotion of Female Education in the Far East (FES) and Lady L. Smith, the wife of the first Bishop of Victoria, in 1860. It was given the name "Diocesan Native Female Training School" (DNFTS, 曰字樓女館), affiliated with the Diocese of the Anglican denomination in Hong Kong. The Committee started the school on Bonham Road, with a small concrete house on a paddy field. It was ordered that English language be used in the school in order to provide an English school environment. The school was soon mired in controversy and got into financial trouble. In 1868, the second Bishop of Victoria, Bishop R. Alford, took the school under his immediate superintendence. This marks the end of the "First Foundation".

        1. The School in Making

        1.1. 1869-1878: Mr. Arthur started it
                On 30 January 1869, Bishop Alford issued an Appeal to extend the benefits of education given in DNFTS to children of both sexes, which was soon met with a liberal response. Under a new constitution and new Committee, the "Diocesan Home and Orphanage" (DHO, 曰字樓孤子院), also known as the "Second Foundation", was begun for English, Eurasian, Chinese and other pupils on the same site in September. The objects of the Institution were to receive children of both sexes and to board, clothe and instruct them with a view to industrial life and the Christian Faith according to the teaching of the Church of England.
                In July 1870, Mr. W. M. B. Arthur (雅瑟先生) of the Garrison School was appointed as the Master (Headmaster), and Mrs. Arthur as the Matron. In 1878, the School was placed in the Grant-in-Aid Scheme by the Education Department, based on its academic performance.
                Mr. Arthur resigned due to the poor health of his wife in 1878. As suggested by the third Bishop, Bishop J. Burdon, the School Committee decided to receive no more boys, but those already admitted should remain. This decision was, however, later strongly opposed by Mr. W. Keswick, a member of the School Committee, who had not been able to attend the last meeting, and the decision was finally reversed in July: no more girls were received as boarders instead, though they still remained as day-scholars, and the School was to transform into a boys' school.

        1.2. 1878-1898: Mr. Piercy brought in merchant houses
                On 1st November, Mr. G. H. Piercy (俾士先生), the third master of the Government Central School, was appointed as the Headmaster, his wife being the Matron. Piercy focused on the academic education of the students, and the School gained satisfactory results in the Cambridge and Oxford Local Examination scholarships. Many graduates started their careers in banks and merchant houses in Hong Kong and other ports along the China seas, the notable ones being Henry Gittins (洪千), Adolph Zimmern (施燦光), Robert Kotewall (羅旭龢) etc. Dr. Sun Yat-sen (孫中山) was also a day boy in 1883. Mr. Piercy was able to maintain the School in good and clean condition during his leadership. An epidemic broke out in Hong Kong in 1886, but fortunately no deaths were reported in DHO.
                Nevertheless, the old and worn-out school building could hardly meet the need of the expanding number of students, and this led to the construction of a New Wing In 1891. Owing to some legal claim to the land, the Home had to change its name slightly and was henceforth called "Diocesan School and Orphanage" (DSO). It was known as 拔萃書室 in Chinese, since the pronunciation of 拔萃 is similar to "Piercy".
                The students were also active in extra-curricular activities in Piercy's time. Music at the School can be traced back to 1896 when its first music organization came into existence as a Drum Fife Band. Sports were popular too. Inter-school competitions were organized, and the School had always been good in football and was the holder of the Junior League Cup. The School first participated in out-of-school activities in 1894. It was registered as a participant of the Belilios Medals, which was later called the Duke of Edinburgh Award.
                In 1892, DSO became a boys' school for the first time as all the girls were transferred to Fairlea Girls' School (later merged with another school and was known as Heep Yunn School), under the superintendence of Ms. M. Johnstone. Ms. Johnstone also played an important part in establishing the Diocesan Girls' School and Orphanage (DGSO) in Rose Villas in the vicinity of DSO on Bonham Road in 1899. To distinguish from DGSO, DSO renamed itself "Diocesan Boys' School and Orphanage" (DBSO) in 1902.

        1.3. 1898-1917: Mr. Sykes taught every boy in it
                During his tenure, Mr. Piercy was always assisted by capable second masters, including Mr. B. Tanner and Mr. H. Sykes (賽克思先生). Mr. Sykes came to DSO in 1898 and succeeded Mr. Tanner as the second master after the latter became the head of the Queen’s College. He acted twice as Headmaster while Mr. Piercy was on leave. A stern yet loving teacher, Mr. Sykes was largely responsible for the excellent Oxford Local examination results obtained by the students in the early part of the century.
                In 1909, The Piercys moved out of the campus since Mrs. Piercy resigned as Matron, and Mr. Piercy had to forsake his post as Warden too. They were succeeded respectively by Mrs. Tuxford and Mr. Sykes. This situation made more interactions possible between Mr. Sykes and the boys, and he became even more beloved in the School. It was through his discussion with Mr. Piercy that a science laboratory was built.
                Mr. Piercy retired in 1917, and the top post was offered to Mr. Sykes provided that he was married and his wife acted as Matron. After his declining, Rev. W. T. Featherstone was appointed as the new Head. Mr. Sykes resigned and left Hong Kong in 1920. He was sorely missed.

        2. Entering a New Phase

        2.1. 1917-1931: Rev. Featherstone built it
                Rev. W. T. Featherstone (費瑟士東牧師) was a man of great vision and vigour. A clergyman of St. Peter's Church of the Seamen Mission in the neighbourhood of DBSO, he was also responsible for the classes of Scripture since 1914. In his office from 1917 to 1931, he introduced the Prefects system, a club system (later renamed house system) and Speech Day since he wished to change DBSO into an English-style public school. Rev. Featherstone saw the importance of globalisation, and would regularly visit the parents and old boys along the China coast and Southeast Asia. According to him, sports were a means of fostering "esprit de corps" amongst the boys. Sports prizes were hence discouraged from 1919 onwards, and no Leagues joined as they encourage professionalism and "pot-hunting". Under the same ideology, he reorganized "Prize Giving Day" to "Speech Day". To celebrate the Golden Jubilee of the School, Rev. Featherstone also published the first history book of the School in 1930, titled The Diocesan Boys School and Orphanage, Hong Kong: The History and Records 1869–1929.
                In addition, Rev. Featherstone proposed moving the School from Bonham Road to Mong Kok Hill in 1926. But soon in March 1927, the British military authorities commandeered the new campus as a hospital in connection with the Shanghai Defence Force of UK because of the Canton-Hongkong Strike Boycott. The School was temporary moved to "Ten Houses" (now Mong Kok Police Station) in the corner of Nathan Road and Prince Edward Road. On returning, the School found that the third storey of the School Building was finished by the military.
                Rev. Featherstone originally planned to sell the old site on Bonham Road and use the revenue to pay the construction fee of the new school. Due to economic depression after the Strike, the buyer of the old site went bankrupt. In 1926, the School Committee had to accept the government's offer of $253,000 for the old site and in addition applied for a loan of $175,000 with a high interest rate of 8%. The School was bogged in severe financial problems. Rev. Featherstone lost the support of the Committee and was forced to quit, heart-broken.

        2.2. 1932-1938: Mr. Sargent saved it
                Mr. C. B. R. Sargent (舒展牧師) was only 26 years old when he headed the School in 1932. Before coming to Hong Kong, he was a successful physics teacher at Wellington School, England. Upon his arrival, the School had a huge debt of $145,000, and would face the danger of being taken over by the government to be used by the Central British School.
                With intelligence and determination, Mr. Sargent saved the School in three ways. First, he appealed for donations and asked every member of the School Committee to endorse an interest-free loan. Second, he sold the east part of the campus to Sir E. Kadoorie and concluded a deal with the government so that the School's mortgage rate would be reduced drastically. Third, he opened new classes, raised the school fees and redecorated the campus. The School soon regained its reputation and classes were filled up rapidly. All the debts would be cleared by around 1940.
                In Mr. Sargent's days, the School Magazine was born in July 1934 as a biannual publication. From the third issue it was named Steps by Rev. L. L. Nash. Mr. Sargent's deep love of music laid the foundations for the musical traditions in the School. Extra-curricular activities were encouraged. The Boy Scout troop was founded by Mr. Sargent in 1932. In order to provide pastoral care to the students, Mr. Sargent was ordained in 1934. He was subsequently appointed bishop of the Diocese of Fukien (福建), which forced him to resign from DBS.

        2.3. 1938-1955: Mr. Goodban made it the best school of its kind
                In 1938 Mr. G. A. Goodban (葛賓先生) was chosen to succeed Rev. Sargent whom he resembled in several respects: a professional schoolmaster, able, young and musical. Attracted by the international characteristics of the School and its orphanage aspect, he accepted the offer in spite of the fact that the Sino-Japanese War had broken out in 1937. Mr. Goodban started to promote musical education further, and took the lead in forming the Hong Kong Schools Music Association in 1940.
                Meanwhile, the students showed their support towards the Chinese Nationalist (KMT) Government. In January 1938, when Rev. Sargent was still the Headmaster, a Shoe-shining Club was organized to raise funds for China. Boys went to schools around Hong Kong, polishing shoes for both teachers and students. In May 1939, it even led to a strike when a Taiwanese student of Japanese nationality was appointed as Senior Prefect.
                In the Dark Christmas of 1941, Hong Kong was taken over by the Japanese army. The School was occupied by Kempi Tai and used as a military hospital to serve the Japanese soldiers. Many of the personnel, including Mr. Goodban and the staff, were interned in p.o.w. camps. Many old boys joined the Hong Kong Volunteer Defence Corps and more than 50 of them were killed during the War. Their names were carved on the Commemorative Plaque inside the outside the School Hall which was unveiled after the War in 1949 by Bishop Hall.
                Though the Japanese surrendered in August 1945, the School was still under the control of the Kempi Tai. It was not until March, 1946 that Mr. J. L. Youngsaye, together with 4 boys, took over the vacated School. Mr. O. V. Cheung (張奧偉先生) and Mr. B. J. Monks acted as headmaster successively until the returning of Mr. Goodban in November. Mr. Goodban immediately started the restorations as he resumed the office.
                In 1947, Steps was re-initiated. In 1948, the Sargent Memorial Chapel was dedicated and the tuck shop was opened. In 1949 a new house system, together with the Piercy Challenge Shield, was introduced. The existing five houses were named after Mr. Sykes and four previous Headmasters, i.e. Messrs. Arthur, Piercy, Featherstone and Sargent. The School uniform was also introduced in the same year.
                As the School continued to flourish, it was felt that a new gymnasium, music, geography and art rooms, a science wing and Headmaster's House should be built. The construction of all but the science wing was completed in 1952. The Diocesan Preparatory School with classes from primary 1 to 4 was opened beside the Christ Church in that year. When the new "forms" were implemented in substitution of the old "classes" in 1953, Mr. Goodban submitted his resignation effective from the following October. In April 1955 the School bade adieu to the man who tried to make it the best of its kind in Hong Kong.

        3. Moving With the Times

        3.1. 1955-1961: Canon She increased its accommodation
                Rev. G. S. Zimmern (施玉麒牧師), a.k.a. Canon George She, was the first local citizen, Eurasian and old boy to become Headmaster. Before returning to DBS, he was a priest, barrister and magistrate, and also a famous social activist who engaged in founding charities and reviving the schools closed during the War. He saw the expansion in the population of Hong Kong and was always soft-hearted to help the poor. He knew his mission in the School was really to increase the accommodation and do a certain amount of reorganization. In the six years under Rev. She the number of students rose from 500 odd to 1100. He opened the School gates wide to boys from lower socioeconomic backgrounds, and introduced the Garden Fête in 1955 to raise funds for the needy students. In addition, he de-colonialized the School by affirming Chinese in the School's culture.
                Rev. She founded the Goodban House in 1956, and did his best to promote sports in the School. He also built heavily on the solid foundation in music. The School Orchestra was re-established and the Chinese orchestra was to be formed. The School also won the Best Boys' Choir in the Music Festival in 1957 and 1958.
                During his tenure, Rev. She always regarded himself as a "caretaker" and felt that Mr. Lowcock should follow in the footsteps of Sargent and Goodban- to be a young headmaster and take on the responsibility as early as possible so as to fully utilize his talents. In 1961 Canon She retired and joined his family in Bristol, England.

        3.2. 1961-1983: Mr. Lowcock strove for its freedom
                Mr. S. J. Lowcock (郭慎墀先生) was appointed as the Headmaster in 1961. He was a "Goodban's boy" in late 1940s and studied physics in HKU. Later he served under Rev. She as the Sports Master. After assuming office, Mr. Lowcock decentralized the administration by appointing teachers to posts with designated responsibilities, such as senior master, Bursar, Warden, Sports Master, Careers Master, etc. The New New Wing, the barbecue pits and the Swimming Pool (outdoor) were being constructed.
                The School Centenary was officiated on 27th January 1969 and a celebration was held together with the introduction of a new blazer badge, which was intended to cut down costs. At the invitation of Mr. Lowcock, Mr. W. J. Smyly, a previous teacher, started the School history project in late 1960s. Though not published eventually, the script includes materials and interviews which can be regarded as a treasure nowadays.
                Mr. Lowcock believed in laissez-faire policy, and the significant contribution that extra-curricular activities could make to develop a boy's character. As the result the School became not only a major force in athletics but also enthusiastic a partaker in music and other activities. The Apple Race was introduced in 1969, and the Timing Squad was formed. The Olympus (阰報), a monthly news-sheet was introduced in 1963, later discontinued and revived with the new title Not Rigmarole (粹聞) in 1978. Steps had acquired its Chinese name 集思 in 1974.
                Under same mentality Mr. Lowcock tried his best to remain the primary section (P5 and P6) in the School. According to him, the children who entered DBS in Primary 5 need not to sit for the Secondary Schools Entrance Examination and would be therefore more able to enjoy the all-round education provided by the School. Under the pressure of the Education Department, nonetheless, the Primary Section was eventually closed in 1970 and moved to the Diocesan Preparatory School.
                In 1983, Mr. Lowcock announced his retirement due to poor health, after striving for freedom in the management and upholding the tradition of the School for 22 years. On departure he realised that his retirement fund had nearly been drained since most of his income was spent on his boys. Without fanfare the old boys found for him a house in Clear Water Bay. In the quiet and peaceful surroundings, Mr. Lowcock utilized his inner strength, modified his life habits, and regained his health and wits.

        3.3. 1983-2000: The Palm Days under Mr. Lai
                Mr. J. Lai (黎澤倫先生) was the first Chinese Headmaster of the School. He was an old boy and an experienced teacher who had worked in DBS over 20 years. To boost school morale, Mr. Lai worked hard to establish more scholarships, prizes and awards for achievement in both academic and extracurricular activities. To celebrate the 120th anniversary in 1989, the Prefects were organized to publish a book of brief history of the School, titled Perpetuation. The first Parents' Day was introduced in 1993, in order to provide a formal occasion for parents to meet with the teachers.
                During the Headmastership of Mr. Lai, renovation and modernisation such as the building of the Language Laboratory, Demonstration Room, the rewiring of the School, the installation of gas pipes, intercom system and new firm alarm system, the repainting of the School walls, the computerisation of the School, and the setup of the computer rooms were performed throughout the School.
                Under Mr. Lai's efforts, the School reached new heights in both academic and non-academic pursuits. An increasing number of students received distinctions in various subjects each year in both the HKCEE and HKALE, led to more DBS boys being accepted into top universities worldwide. Orators, scholars, athletes and musicians of the School achieved outstanding results in various competitions. Many trophies were brought back to the School as a result.
                After 17 years of loyal service, Mr. Lai retired in August 2000. His devotion to the School, perseverance and compassion for the students gained him wide respect in both the School and wider education circles in Hong Kong.

        3.4. 2000-2012: The New Millenium under Mr. Chang
                Mr. Terence Chang (張灼祥先生), an old boy and principal of another school, was appointed to succeed Mr. Lai as the ninth Headmaster of DBS in 2000.
                During Mr. Chang's early days as the Headmaster, the Student Council and Parent-Teacher Association (PTA) were formed. In 2002, the School Committee has decided to move DBS from the Grant-in-Aid code to join the Direct Subsidy Scheme (DSS) which eventually takes effect on 1st September, 2003. The through-train primary school, known as the Diocesan Boys' School Primary Division (DBSPD), had its first (partial) intake of students in 2004. It further expanded its intake with students aged between 6 and 12 in 2005. DBS has also been authorized as an International Baccalaureate (I.B.) World School by the I.B. Organisation in 2010.
                Under his tenure, a number of buildings have been erected, including the Primary Division (2004), Mrs. Tsai Ming Sang Building (2005, a.k.a. School Improvement Programme, SIP), Samuel Tak Lee Building (a.k.a. Sports and Dormitory Building), Michiko Miyakawa Building (a.k.a. the I.B. Block, which also houses the new School Chapel, namely St. Augustine's Chapel) and the Yunni & Maxine Pao Auditorium. Because of the physical expansion, some old buildings and facilities were abolished, including the old Headmaster's House, the New Wing (old Gymnasium, Art Room, Geography Room and Music Room), Shower House, two of the outdoor tennis courts, one basketball court (a.k.a. Steps Court), the auxiliary staff quarters, etc.
                On 1st September 2011 Mr. Chang declared his retirement in the coming August. On the Speech Day in the following January, the appointment of Mr. Ronnie Cheng as Headmaster Designate was announced by The Rt. Rev. Louis Tsui, Bishop of Diocese of Eastern Kowloon and Chairman of the School Committee. Mr. Cheng was the Deputy Headmaster (Dean of Culture) and Music Maestro, and also an old boy of the School.

        Bibliography
        \u{2022} Rev. W. T. Featherstone, The Diocesan Boys School and Orphanage, Hong Kong: The History and Records 1869–1929 (Hong Kong: Ye Olde Printerie Ltd, 1930)
        \u{2022} W. J. Smyly, A History of the Diocesan Boys' School (unpublished manuscript circa 1967)
        \u{2022} Author Unknown, "A brief history of DBS", Steps 1978 (Hong Kong: Diocesan Boys' School, 1978), pp8-20.
        \u{2022} The Perpetuation Editors, Perpetuation (Hong Kong: Diocesan Boys' School, 1989)
        \u{2022} The GS Book Editors, A Tribute to Rev. Canon George She, Headmaster 1955–1961 Diocesan Boys' School (Hong Kong: The Green Pagoda Press, 2004)
        \u{2022} DSOBA, Diocesan Boys School 135th Anniversary (Hong Kong: Diocesan Boys' School, 2004)
        \u{2022} Fung Yee Wang and Chan-Yeung Mo Wah Moira, To Serve and to Lead: A History of the Diocesan Boys' School, Hong Kong (Hong Kong: Hong Kong University Press, 2009)
        \u{2022} Dr. Pau Wing Iu, Patrick, "A Tribute to Sydney James Lowcock", http://dsoba.dsoba.com/index.php?option=com_content&view=article&id=524:a-tribute-to-sydney-james-lowcock-dr-pau-wing-iu-patrick&catid=239:memories&Itemid=217 (retrieved on 1st August, 2012)
        """}(), ["Prologue", "1. The School in Making", "1.1. 1869-1878: Mr. Arthur started it", "1.2. 1878-1898: Mr. Piercy brought in merchant houses", "1.3. 1898-1917: Mr. Sykes taught every boy in it", "2. Entering a New Phase", "2.1. 1917-1931: Rev. Featherstone built it", "2.2. 1932-1938: Mr. Sargent saved it", "2.3. 1938-1955: Mr. Goodban made it the best school of its kind", "3. Moving With the Times", "3.1. 1955-1961: Canon She increased its accommodation", "3.2. 1961-1983: Mr. Lowcock strove for its freedom", "3.3. 1983-2000: The Palm Days under Mr. Lai", "3.4. 2000-2012: The New Millenium under Mr. Chang", "Bibliography"])
        hideButtons()
    }
    @IBAction func houses(_ sender: Any) {
        hideButtons()
    }
    @IBAction func schoolBadge(_ sender: Any) {
        hideButtons()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        self.title = "Vision and Mission"
        vAndM(self)
        
        information.textAlignment = .justified
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attributedText(_ str: String, _ titles: [String]) -> NSAttributedString {
        let string = str as NSString
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0)])
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0)]
        for i in titles {
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: i))
        }
        
        return attributedString
    }
    
    func hideButtons() {
        UIView.animate(withDuration: 0.3) {
            self.aboutDBSCollectionView.forEach {
                $0.isHidden = !$0.isHidden
            }
        }
    }
    
}




