<?php

namespace App\Controllers;

class Home extends BaseController
{
    public function index(): string
    {
        // return view('welcome_message');
        return file_get_contents(FCPATH . 'index.html');
    }
}
