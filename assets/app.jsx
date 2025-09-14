import React from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import './app.css'

function App() {
  return (
    <Router>
      <div className="App">
        <header className="App-header">
          <h1>Symfony 7.3 + React 18</h1>
          <nav>
            <ul>
              <li><a href="/">Home</a></li>
              <li><a href="/about">About</a></li>
            </ul>
          </nav>
        </header>
        
        <main>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/about" element={<About />} />
          </Routes>
        </main>
      </div>
    </Router>
  )
}

function Home() {
  return (
    <div>
      <h2>Welcome Home!</h2>
      <p>This is a Symfony 7.3 backend with React 18 frontend.</p>
    </div>
  )
}

function About() {
  return (
    <div>
      <h2>About</h2>
      <p>Built with PHP 8.3, Node.js 22, Symfony 7.3, and React 18.</p>
    </div>
  )
}

const container = document.getElementById('root')
if (container) {
  const root = createRoot(container)
  root.render(<App />)
}
