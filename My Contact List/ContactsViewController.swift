//
//  ContactsViewController.swift
//  My Contact List
//
//  Created by Cistudent on 4/1/20.
//  Copyright © 2020 Cistudent. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var currentContact: Contact?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtCell: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtHomeEmail: UITextField!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var imgContactPicture: UIImageView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblHomePhone: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if currentContact != nil {
            txtName.text = currentContact!.contactName
            txtAddress.text = currentContact!.streetAddress
            txtCity.text = currentContact!.city
            txtState.text = currentContact!.state
            txtZip.text = currentContact!.zipCode
            txtPhone.text = currentContact!.phoneNumber
            txtCell.text = currentContact!.cellNumber
            txtEmail.text = currentContact!.email
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentContact!.birthday != nil {
                lblBirthdate.text = formatter.string(from:currentContact!.birthday as! Date)
            }
            
            if let imageData = currentContact?.image as? Data {
                imgContactPicture.image = UIImage(data: imageData)
            }
            
        }
        
        // Do any additional setup after loading the view.
        self.changeEditMode(self)
        
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip, txtPhone, txtCell, txtEmail, txtHomeEmail]
        for textfield in textFields {
            textfield.addTarget(self,
                                action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                                for: UIControlEvents.editingDidEnd)
            
        }
        
        let longPress = UILongPressGestureRecognizer.init(target: self,
                                                          action: #selector(callPhone(gesture:)))
        lblPhone.addGestureRecognizer(longPress)
        
        let longPress2 = UILongPressGestureRecognizer.init(target: self,
                                                          action: #selector(textPhone(gesture:)))
        
        lblHomePhone.addGestureRecognizer(longPress2)
    }
    
    func callPhone(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let number = txtCell.text
            if number!.characters.count > 0 {
                let url = NSURL(string: "telprompt://\(number!)")
                UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
                print("Calling Phone Number: \(url!)")
            }
        }
    }
    
    func textPhone(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let number = txtPhone.text
            if number!.characters.count > 0 {
                let url = NSURL(string: "sms://\(number!)")
                UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
                print("Texting Phone Number: \(url!)")
            }
        }
    }
    
    
    @IBAction func changePicture(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
            cameraController.cameraCaptureMode = .photo
            cameraController.delegate = self
            cameraController.allowsEditing = true
            self.present(cameraController, animated: true, completion: nil)
        }
    }
    
    

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgContactPicture.contentMode = .scaleAspectFit
            imgContactPicture.image = image
            if currentContact == nil {
                let context = appDelegate.persistentContainer.viewContext
                currentContact = Contact(context: context)
            }
            currentContact?.image = NSData(data: UIImageJPEGRepresentation(image, 1.0)!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        currentContact?.contactName = txtName.text
        currentContact?.streetAddress = txtAddress.text
        currentContact?.city = txtCity.text
        currentContact?.state = txtState.text
        currentContact?.zipCode = txtZip.text
        currentContact?.cellNumber = txtCell.text
        currentContact?.phoneNumber = txtPhone.text
        currentContact?.email = txtEmail.text
        currentContact?.homeEmail = txtHomeEmail.text
        
        return true
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip, txtCell, txtPhone, txtEmail, txtHomeEmail]
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextBorderStyle.none
            }
            btnChange.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextBorderStyle.roundedRect
            }
            btnChange.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self,
                                                                action: #selector(self.saveContact))
        }
    }
    
    func saveContact() {
        if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        appDelegate.saveContext()
        
         print("You saved a new contact!")
        
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    func dateChanged(date: Date) {
        if currentContact != nil {
            currentContact?.birthday = date as NSDate?
            appDelegate.saveContext()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            lblBirthdate.text = formatter.string(from: date)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueContactDate") {
            let dateController = segue.destination as! DateViewController
            dateController.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let settings = UserDefaults.standard
        txtState.text = settings.string(forKey: Constants.kDefaultState)
        
        self.unregisterKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsViewController.keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
        
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        
        self.scrollView.contentInset = contentInset
        
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
