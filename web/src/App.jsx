import { Navigate, Route, Routes } from 'react-router';
import LayoutPrincipal from './layouts/LayoutPrincipal';
import Estacionamientos from './pages/Estacionamientos';
import NoEncontrada from './pages/NoEncontrada';
import InicioSesion from './pages/InicioSesion';
import Panel from './pages/Panel';

function App() {
  return (
    <Routes>
      <Route path="/" element={<Navigate to="/panel" replace />} />
      <Route path="/auth" element={<InicioSesion />} />

      <Route element={<LayoutPrincipal />}>
        <Route path="/panel" element={<Panel />} />
        <Route path="/estacionamientos" element={<Estacionamientos />} />
      </Route>
      <Route path="*" element={<NoEncontrada />} />
    </Routes>
  );
}

export default App;