//
//  housesSystemViewController.swift
//  DBS
//
//  Created by Ben Lou on 18/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

class housesSystemViewController: UIViewController {

    @IBOutlet weak var housesSystem: UITextView!
    let sliderView = UIView()
    let slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let string = """
A brief introduction to our House System
    Unlike many other schools in Hong Kong, the house system of DBS has a unique historical development. Under Rev. Featherstone's Headmastership, in 1922 the School has been divided into four Houses for House Sports, and to get as many boys as possible to do something for their Houses and for the School. The Houses were represented for four different colours (blue, brown, green and yellow). Rev. Sargent, the successor of Rev. Featherstone, extended the house system to cover senior and junior grades in various sports.
    DBS has re-established the house system after the war and added a fifth house, the Red House, in 1947. From 1949 onwards, all Houses were named after the School's past Headmasters, i.e. Arthur (green), Piercy (blue), Featherstone (yellow), Sargent (red), with the exception of Sykes (brown) who, although was not a headmaster, was honoured for his contribution as a former First Assistant Master (Deputy Headmaster), acted twice as Headmaster when Mr. Piercy was on leave and Resident Master, the de facto Head, after Mr. and Mrs. Piercy moved out from the School Campus. The Goodban House (light blue), Lowcock House (purple) and George She House (orange) were established in 1956, 2002 and 2011 respectively to honour the fifth, sixth and seventh headmasters of DBS.
    The Piercy Challenge Shield (from 1947/1948 for Athletics and Swimming), Drama Shield (from 1957/58) and Centenary Shield (from 1968/69 for all other sports) are awarded each year for the wining house in the inter-house competitions.

Roster of Headmasters

1) Mr. W. M. B. Arthur    1870-1878
Co-educational period.

2) Mr. G. H. Piercy    1878-1917
A boys' school was transformed in 1891.

3) Rev. W. T. Featherstone    1917-1931
The campus was moved from the Island to Kowloon in Mr. H. du Toit Pyner
1931-1932     Acting.
Mr. Pyner was a botanist and introduced various kinds of plants to the new (Mongkok) campus.

4) Rev. C. B. R. Sargent    1932-1938
Rev. Sargent saved the School from financial crisis by selling the eastern part of the hill to the Kadoories.

5) Mr. G. A. Goodban    1938-1941
Mr. Goodban was interned in the Shumshuipo p.o.w. camp during the war.

Japanese Occupation
Mr. O. V. Cheung    1946    Acting.
A Eurasian and old boy, Sir Oswald was still an undergraduate of HKU when appointed. Later he furthered his study in Oxford University and became a Queen's counsel.
Mr. B. J. Monks    1946    Acting.

5) Mr. G. A. Goodban    1946-1955
Mr. B. J. Monks    1955    Acting.

6) Canon G. She    1955-1961    The first Eurasian and old boy to become Headmaster.

7) Mr. S. J. Lowcock    1961-1983
The first head with a degree of local tertiary institutions (HKU).

8) Mr. J. Lai    1983-2000
The first Chinese Headmaster.

9) Mr. T. Chang    2000-2012
The School joined the DSS.

10) Mr. R. Cheng
2012-

Arthur started it.
Piercy brought in the merchant houses.
Sykes taught everyone in it.
Featherstone built it.
Sargent saved it.
Goodban made it the best school of Hong Kong.
George She increased its accommodation.
Lowcock strove for its freedom.

Mr. William Monarch Burnside ARTHUR (雅瑟先生)
    Mr. W. M. B. Arthur was the first Headmaster of Diocesan Boys' School, Hong Kong (1870 - 1878). He was born in Surrey, England on 21st December 1839 and arrived at Hong Kong in 1864, teaching at Garrison School. In 1870, Mr. Arthur was employed as the Master (Headmaster) of the newly formed Diocesan Home and Orphanage (DHO). His wife Mary Annie Vaughan was the Matron. During the days of Mr. Arthur, there was no significant increase in student number but donations from various sectors of the community became more regular, sustaining the operation of the school. In 1878, DHO became a grant-in-aid school.
    At that very year, since his wife could no longer take up the post of Matron owing to poor health, Mr. Arthur resigned his office and became the second master of Central Government School (now Queen's College). Subsequently, he was also the first clerk of magistracy and the principal of Police School. Mr. Arthur returned to England after retirement in May 1900 and passed away in Cornwall on 27th January 1912.

Mr. George H. PIERCY (俾士先生)
    Mr. G. H. Piercy was the second Headmaster of DBS (1878 - 1917). He was born in Canton (now Guangzhou) in the autumn of 1856. In his early days, Mr. Piercy was called G. Piercy Jr. His father, Rev. G. Piercy, was an English priest and the founder of the Methodist Church in Hong Kong. Piercy Jr. was educated in Canton in his childhood. He later went to England and graduated with a University of London degree. From 1874, he subsequently worked as an instructor of English at Tungwen Kuan (同文館) in Canton and the third master of Central Government School in Hong Kong. On 1st November, 1878, Mr. Piercy was appointed to the headmastership of DHO. In the following summer he married Ms. Jane Smailes, who became the Matron and began her 30 years' loyal service. Dr. Sun Yat-sen was a day scholar of DHO in 1883.
    In 1891, a new wing was completed and the institution was renamed as Diocesan School and Orphanage (DSO). All the female pupils were transferred to Fairlea Girls' School (the forerunner of Heep Yunn School) and DSO became a purely boys' school. On 23rd May, 1892, the Legislative Council passed the Ordinance of Diocesan School and Orphanage. In 1899, Diocesan Girls' School and Orphanage was set up at Rose Villas in the vicinity of DSO on Bonham Road. Three years later, DSO was renamed Diocesan Boys' School and Orphanage (DBSO).
    In 1917, Mr. Piercy resigned his office and resided with his spouse next year in Victoria B.C., Canada. He had been Headmaster for 39 years and the School expanded quickly during his time, nurturing many talents and was ranked amongst the famous schools in Hong Kong. Born in a priest's family in Canton, he was a strict disciplinarian and a religious man, and was very interested in the education of Chinese boys. Also, Mr. Piercy was closely in touch with the business interests in Hong Kong, and his School prepared boys for bilingual apprentices for employment in merchant houses along the China Coast. Indeed, the Chinese name (拔萃) of the School was a spoonerism of his name. He passed away in Victoria B.C. on 3rd October 1941, aged 85.

Mr. Henry O. E. SYKES (賽克思先生)
    Mr. H. O. E. Sykes joined DSO in 1898 and became First Assistant Master within a year. He acted twice as Headmaster while Mr. Piercy was on leave. In 1909 Mrs. Piercy retired from the post of Matron and the Piercys moved out of the campus. Mr. Sykes became the Resident House Master in the same year. He was the de facto Head of the School and had good interaction with the boys. Responsible for the School's excellent academic record, he was a very good disciplinarian, but never used his cane or resorted to punishment.
    Following Mr. Piercy's submission of resignation, the top post was offered to Mr. Sykes provided that he was married and his wife acted as Matron. However Mr. Sykes preferred to remain celibate. He declined the offer and resigned in 1920. After his returning to England no one was able to find him. He was sorely missed. As said by Canon George She, one of his pupils, "I saw a good deal of Sykes and I think we all loved him."

Rev. William Thornton FEATHERSTONE (費瑟士東牧師)
    Rev. W. T. Featherstone was the third Headmaster of DBS (1917 - 1931). He was born in Liverpool, England on 21st April 1886. He graduated from Oxford University and served at St. Peter Seamen's Church in Sai Ying Pun, Hong Kong. From 1914 onwards, Rev. Featherstonetaught Scripture at DBSO and was appointed the Headmaster on 4th December 1917.
    During his term of office, Rev. Featherstone initiated a series of reforms, including the establishment of the Speech Day, the Prefects Board and the House (Club) system. In addition, prizes for sports were discouraged from 1919 onwards. From 1922 no prizes have been given in the School, and no leagues joined as they encouraged professionalism and "pot-hunting". As the Golden Jubilee was coming, Rev. Featherstone compiled the first history book of the School, titled The Diocesan Boys School and Orphanage, Hong Kong: The History and Records 1869-1929.
    Rev. Featherstone was a man of far reaching vision. He dreamt of transforming DBSO into an English-style public school, and making it more international. In the summer holidays he had tours to meet parents in Swatow, Amoy, Formosa (now Taiwan), Manila and so on. The School had such a good name among the Chinese in these different places that there were quite a large number came. The first Head Prefect, Kor Bu-lok of class 1919, was Taiwanese. Students of more than thirteen nationalities were observed in Featherstone's time.
    In addition, Rev. Featherstone understood that the old Bonham Road campus was no more suitable for the expanding DBSO. He proposed selling the old site on the Hong Kong Island in search for a new campus in Kowloon. In 1926, the School was relocated to Mongkok Hill. Owing to the Canton-Hongkong Strike, regrettably, the buyer of the Bonham site went bankrupt and consequently, the School also ran into financial difficulty. Heart-broken, Rev. Featherstone left the office in 1931.
    In 1932, Rev. Featherstone became the vicar of St. Paul's Church in Hook of Surrey, England, until his death in Surbiton on 13th November, 1944.

The Rt. Rev. Christopher Birdwood Roussel SARGENT (舒展會督)
    The Rt. Rev. C. B. R. Sargent was the fourth Headmaster of DBS (1932 - 1938). He was born into an ecclesiastical family in England on 4th June 1906. He was educated at St Paul's School and St Catharine's College, Cambridge and worked as a physics master at Wellington College, Sandhurst. Invited by Bishop C. R. Duppuy of Hong Kong, Mr. Sargent became the Headmaster of DBS in 1932.
    Right after his assumption of office, Mr. Sargent sold the eastern part of the campus to Sir E. Kadoorie and paid the debt with the income. The financial situation of the School improved considerably. Mr. Sargent encouraged sports and music activities in the School and was the music master himself. He had a collection of opera records and every Friday night he gave an illustrated lecture over RTHK. He re-installed the prize-giving section on Speech Day and continued the tradition of summer tours of Rev. Featherstone. When Sino-Japanese War broke in 1937, a Shoe-shining Club was soon organized under the support of Rev. Sargent to raise funds for the Nationalist Government. Boys went to schools around Hong Kong, polishing shoes for both teachers and students. The eloquence, negotiating skill and entrepreneurial methods of Mr. Sargent successfully revived the School's excellent reputation. His short tenure was a time of consolidation after a period of rapid expansion.
    Mr. Sargent was ordained as a deacon in the School Chapel in 1934. In 1938 he was consecrated as the Assistant Bishop and then Bishop of the Diocese of Fukien in 1938. He died of malaria in Foochow on 8th August 1943.

Mr. Gerald Archer GOODBAN (葛賓先生)
    Mr. G. A. Goodban was the fifth headmaster of DBS (1938 - 1941 and 1946 - 1955). He was born in Chiswick, West London of England on 13th February, 1911. After graduating from Tonbridge School, he won an open classical scholarship to attend Lincoln College, Oxford, reading Greats. He graduated in 1933 with M.A. and became a classics master at Bishop Startford's College, and was the travelling secretary of the Student Christian Movement at the time.
    On 23rd November, 1938, Mr. Goodban assumed the headmastership of DBS. School administration apart, he also introduced subjects such as English language, English literature, history, the Bible, physical education and music, which were all well received. In 1940, he took part in organizing and establishing the Interschool Society of Music and Drama. Mr. Goodban joined the Royal Hong Kong Regiment on the outbreak of the Pacific War in 1941. Upon the fall of Hong Kong in December, he was interned at the Shamshuipo Prisoner of War(POW) camp.
    Released in 1945 upon the liberation of Hong Kong, he returned to England for recuperation. He came back and resumed his office on 19th November, 1946. In 1951, he proposed reviving the Hong Kong Schools Music Association and prepared for the first Hong Kong Schools Music Festival. Mr. Goodban's philosophy of providing an all-round education was the guideline principle for his successors. The School's re-establishment and pre-eminent position are ascribed to his hard working. He tendered his resignation in 1953, leaving Hong Kong in April, 1955.
    Having returned to England, he taught in turn at Charterhouse School, Rugby College and Marlborough College. In April 1959, He succeeded as the principal of the King's School, Grantham, and stayed until retiring in 1972. After retirement, he was once the chair of the Rotary Club at Grantham. He died on 21st March, 1989, aged 78.
    In collaboration with others, Mr. Goodban authored the book China in World History.

Rev. George Samuel ZIMMERN (施玉麒牧師)
    Rev. G. S. Zimmern J.P., also named as Canon George She, was the sixth Headmaster of DBS (1955-1961). Born of Eurasian parentage on 17 February 1904, he attended DBS, followed by Oxford University in England where he read Modern Greats. He came first in the General Ordination Examination in St. Augustine's College in 1933 and was qualified as a barrister-at-law in Gray's Inn in 1934.
    After returning to Hong Kong in late 1930's, Mr. She became a well-known social activist. Some of his most remarkable jobs included lawyer, magistrate, and Master of St. John's College. As a close friend and supporter of Bishop R. O. Hall, Mr. She was one of the founders of the Street Sleepers' Shelter Society, the Boys' and Girls' Clubs Association, the Housing Society and a number of workers' children schools. During the Pacific War Mr. She was once imprisoned by the Japanese. After the War he was ordained as a deacon and then a priest of St. John's Cathedral, responsible for saving it from bankruptcy.
    As suggested by Bishop Hall, Rev. She was appointed to the headmastership of DBS in 1955, the first Hong Kong-born old boy to become so. He brought about many innovations. Firstly, Rev. She opened the School gates wide to pupils from lower socioeconomic backgrounds, the number of students increased from 600 in 1955 to nearly 1100 in 1961. Secondly, he de-colonialized DBS by affirming Chinese in the School's culture. Rev. She also introduced the Garden Fête in 1955. The students' enthusiasm of participation in music and sports continued. The School Orchestra was organized in the year 1955/56 and Chinese instruments classes were started in 1960, which laid the foundation for the formation of the Chinese Orchestra.
    Rev. She submitted his resignation and left the School in 1961. Before the departure he was appointed as the Honorary Canon of St. John's Cathedral. Canon Zimmern worked at Bristol Cathedral School for seven years since 1962, and was made Priest-in-Charge of Christ Church with St. Ewen in the City of Bristol until his death on 19 November 1979.

Mr. Sidney James LOWCOCK (郭慎墀先生)
    Mr. S. J. Lowcock, M.B.E., J.P., was the seventh Headmaster of DBS (1961 - 1983). He was born to a family of British and Parsee descent in Hong Kong on 11th December 1930. Mr. Lowcock was the great-grandson of Henry Lowcock, one of the earliest Committee members of DHO; while his father, also called Henry, was a merchant and civil engineer, died during his service with the Royal Air Force (RAF) in the WWII in Karachi, India (now Pakistan) in 1943. Mr. Lowcock's family was interned by the Japanese in 1942 when living in Canton and was taken by boat to Shanghai where the family was interned and subsequently travelled by boat to Lorenzo Marques, Mozambique, as exchange POW for Japanese personnel, then travelling on to India where they lived till end of the war. When in Karachi, Mr. Lowcock attended Karachi Grammar School till his return to Hong Kong towards the end of 1946.
    In 1947, Mr. Lowcock was enrolled at DBS and eighteen months later, admitted to the University of Hong Kong, studying physics. One year after his graduation in 1952, he returned to DBS to teach physics and also became the Sports Master. He succeeded his remote cousin Rev. She as the Headmaster in 1961.
    During his term of office at DBS, Mr. Lowcock encouraged a liberal learning atmosphere and was a champion of sports and musical activities. A believer in laissez-faire ideology, he structured the administration to improve efficiency and more teachers were appointed to posts with designated responsibilities. Mr. Lowcock was also a supporter of corporal punishments and his caning was famous among the boys. To celebrate the Centenary in 1969, Mr. Lowcock invited Mr. W.J. Smyly to write a new history book of the School. Though never published, this huge script provides essential materials of the School history.
    In 1983, Mr. Lowcock retired on health ground. While working as the Headmaster, he has long supported poor students with his personal emolument, leaving himself little on retirement. In view of this, DSOBA/Dr. Pau Wing Iu Patrick and a number of alumni staged a fundraising campaign to top up his Provident Fund. Mr. Lowcock passed away in Hong Kong on 26th January 2012, aged 81.
    Mr. Lowcock had written a short story book, Seven Grains of Rice.

We would like to express our cordial gratitude to the following people who gave us invaluable help:
Ms. Margarite Logie
Mr. David Oakley
Ms. Jann LaValley
Mr. Nicholas Goodban
Mr. David Goodban
Dr. David Zimmern
Mrs. Alwyn Wong
Mr. Keith Lowcock

""" as NSString
        var attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0)])
        var boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0)]
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            attributedString = NSMutableAttributedString(string: string as String, attributes:
                [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")))])
            boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")+4))]
        }
        
        let titles = ["A brief introduction to our House System", "Roster of Headmasters", "Mr. William Monarch Burnside ARTHUR (雅瑟先生)", "Mr. George H. PIERCY (俾士先生)", "Mr. Henry O. E. SYKES (賽克思先生)", "Rev. William Thornton FEATHERSTONE (費瑟士東牧師)", "The Rt. Rev. Christopher Birdwood Roussel SARGENT (舒展會督)", "Mr. Gerald Archer GOODBAN (葛賓先生)", "Rev. George Samuel ZIMMERN (施玉麒牧師)", "Mr. Sidney James LOWCOCK (郭慎墀先生)", "We would like to express our cordial gratitude to the following people who gave us invaluable help:"]
        for i in titles {
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: i))
        }
        housesSystem.scrollsToTop = true
        housesSystem.attributedText = attributedString
        housesSystem.textAlignment = .justified
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        housesSystem.setContentOffset(CGPoint.zero, animated: true)
        
        // Slider Components
        
        let setFontSizeButton = UIBarButtonItem(title: "Aa", style: .plain, target: self, action: #selector(setFontSize))
        self.navigationItem.rightBarButtonItem = setFontSizeButton
        
        sliderView.backgroundColor = UIColor.lightGray
        sliderView.frame = CGRect(x: 8, y: self.view.frame.height, width: self.view.frame.width - 16, height: 50)
        sliderView.layer.cornerRadius = 20
        sliderView.layer.zPosition = 1000
        self.view.addSubview(sliderView)
        
        slider.frame = CGRect(x: self.view.frame.width*0.25, y: 20, width: self.view.frame.width/2, height: 20)
        slider.minimumValue = 8
        slider.maximumValue = 24
        
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            slider.value = Float(UserDefaults.standard.integer(forKey: "fontSize"))
        } else {
            slider.value = 16
        }
        sliderValueChanged(slider)
        
        slider.isContinuous = true
        slider.tintColor = UIColor.purple
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        sliderView.addSubview(slider)
        
        //        let sliderTitle = UILabel()
        //        sliderTitle.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: 65)
        //        sliderTitle.text = "Adjust Font Size"
        //        sliderTitle.textAlignment = .center
        //        sliderTitle.font = UIFont(name: "Helvetica Bold", size: 30)
        //        sliderView.addSubview(sliderTitle)
        let smallA = UILabel(frame: CGRect(x: self.view.frame.width*0.15, y:0, width: self.view.frame.width/10, height: 50))
        smallA.text = "A"
        smallA.font = UIFont(name: "Helvetica Bold", size: 9)
        sliderView.addSubview(smallA)
        let bigA = UILabel(frame: CGRect(x: self.view.frame.width*0.85, y:0, width: self.view.frame.width/10, height: 50))
        bigA.text = "A"
        bigA.font = UIFont(name: "Helvetica Bold", size: 30)
        sliderView.addSubview(bigA)
    }
    
    func setFontSize(_ sender: UIBarButtonItem) {
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishedSetFontSize(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
        //        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sliderView.frame.origin.y = self.view.frame.height - (self.tabBarController == nil ? 15: (self.tabBarController?.tabBar.frame.height)!) - 50
        }, completion: nil)
    }
    func finishedSetFontSize(_ sender: UIBarButtonItem?) {
        let setFontSizeButton = UIBarButtonItem(title: "Aa", style: .plain, target: self, action: #selector(setFontSize))
        self.navigationItem.rightBarButtonItem = setFontSizeButton
        //        self.view.backgroundColor = UIColor.white
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sliderView.frame.origin.y = self.view.frame.height
        }, completion: nil)
    }
    func sliderValueChanged(_ sender: UISlider) {
        UserDefaults.standard.set(Int(sender.value), forKey: "fontSize")
        
        viewDidLoad()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
