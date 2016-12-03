---
layout: post
title: Simple authentication in Zend Framework
date: 2010-02-09 14:56:59.000000000 +00:00
categories:
- Zend 
- PHP
tags:
- zend_auth
- zend_form
---
<p>This is quick example of how to do a very simple authentication in Zend Framework. It doesn't user external database for getting the credentials, although you can make it very easily to read data in the Auth adapter from an external file or MySQL database.</p>
<p><!--more-->So, firstly we will create our authentication adapter:<br />
[php]<br />
&lt;?php<br />
// library/My/Auth/Adapter.php</p>
<p>class My_Auth_Adapter implements Zend_Auth_Adapter_Interface {<br />
	protected $_username;<br />
	protected $_password;</p>
<p>	public function __construct($options){<br />
		$this-&gt;_username=$options['username'];<br />
		$this-&gt;_password=$options['password'];<br />
	}</p>
<p>	public function authenticate(){<br />
		$users=array('username'=&gt;'SUPERpassword');</p>
<p>		if(!isset($users[$this-&gt;_username])) {<br />
			return new Zend_Auth_Result(Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND,$this-&gt;_username);<br />
		}</p>
<p>		if(isset($users[$this-&gt;_username]) &amp;&amp; $users[$this-&gt;_username] != $this-&gt;_password) {<br />
			return new Zend_Auth_Result(Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID,$this-&gt;_username);<br />
		}</p>
<p>		if(isset($users[$this-&gt;_username]) &amp;&amp; $users[$this-&gt;_username] == $this-&gt;_password) {<br />
			return new Zend_Auth_Result(Zend_Auth_Result::SUCCESS,$this-&gt;_username);<br />
		}</p>
<p>		return new Zend_Auth_Result(Zend_Auth_Result::FAILURE_UNCATEGORIZED,$this-&gt;_username);<br />
	}<br />
}<br />
[/php]<br />
Next, we'll create a login form:<br />
[php]<br />
&lt;?php<br />
// library/My/Form/LoginForm.php</p>
<p>class My_Form_LoginForm extends Zend_Form {<br />
    public function init()<br />
    {<br />
        $username = $this-&gt;addElement('text', 'username', array(<br />
            'filters'    =&gt; array('StringTrim', 'StringToLower'),<br />
            'validators' =&gt; array(<br />
                'Alpha',<br />
                array('StringLength', false, array(3, 20)),<br />
            ),<br />
            'required'   =&gt; true,<br />
            'label'      =&gt; 'Username:',<br />
        ));</p>
<p>        $password = $this-&gt;addElement('password', 'password', array(<br />
            'filters'    =&gt; array('StringTrim'),<br />
            'validators' =&gt; array(<br />
                'Alnum',<br />
                array('StringLength', false, array(6, 20)),<br />
            ),<br />
            'required'   =&gt; true,<br />
            'label'      =&gt; 'Password:',<br />
        ));</p>
<p>        $login = $this-&gt;addElement('submit', 'login', array(<br />
            'required' =&gt; false,<br />
            'ignore'   =&gt; true,<br />
            'label'    =&gt; 'Login',<br />
        ));</p>
<p>        // We want to display a 'failed authentication' message if necessary;<br />
        // we'll do that with the form 'description', so we need to add that<br />
        // decorator.<br />
        $this-&gt;setDecorators(array(<br />
            'FormElements',<br />
            array('HtmlTag', array('tag' =&gt; 'dl', 'class' =&gt; 'zend_form')),<br />
            array('Description', array('placement' =&gt; 'prepend')),<br />
            'Form'<br />
        ));<br />
    }<br />
}<br />
 [/php]<br />
Next, we have to tell ZF where to find our custom classes, so we put in the bootstrap.php:</p>
<pre lang="php" colla="+">
// application/bootstrap.php

/* Set up autoload so we don't have to explicitely require each Zend Framework class */
require_once "../library/Zend/Loader/Autoloader.php";
$autoloader = Zend_Loader_Autoloader::getInstance();
$autoloader->registerNamespace('My_');
</pre>
<p>And now the final touch, the controller. We'll need there two things:</p>
<ul>
<li>preDispatch hook to check if the user is authenticated (i'm assuming that every action in AdminController needs authentication)</li>
<li>login action that is in fact displaying and processing the form</li>
</ul>
<p>So, here goes:</p>
<pre lang="php" colla="+">
<?php // application/controllers/AdminController.php

class AdminController extends Zend_Controller_Action {
	
  	public function  preDispatch(){
        if (!Zend_Auth::getInstance()?>hasIdentity()) {
            // If the user is not authenticated redirect to the login form
        	if ('login' != $this->getRequest()->getActionName()) {
            	$this->_helper->redirector('login');
        	}
        }
    }
	
	public function indexAction(){

	}
	
	public function  loginAction(){
        $request = $this->getRequest();
	$this->view->form = new My_Form_LoginForm(array('method' => 'post'));
		
        // Check if we have a POST request
        // if not, display login form
        if (!$request->isPost()) {
        	return $this->render("login");
        }

        // Get our form and validate it
        if (!$this->view->form->isValid($request->getPost())) {
            // Invalid entries - render form
            return $this->render('login'); // re-render the login form
        }

        // Get our authentication adapter and check credentials
        $adapter = new My_Auth_Adapter($this->view->form->getValues());
        
        $auth    = Zend_Auth::getInstance();
        
        $result  = $auth->authenticate($adapter);
        if (!$result->isValid()) {
            // Invalid credentials
            $this->view->form->setDescription('Wrong login!');
            return $this->render('login'); // re-render the login form
        }

        // We're authenticated! Redirect to the admin/index action 
        $this->_helper->redirector('index', 'admin');
    }
    
    public function  logoutAction(){
        Zend_Auth::getInstance()->clearIdentity();
        $this->_helper->redirector('index','index'); // back to login page
    }
	
}
</pre>
<p>That's all!<br />
But remember, this is only a simple authentication.<br />
You have to remember about making it more secure via enforcing HTTPS connection!</p>
