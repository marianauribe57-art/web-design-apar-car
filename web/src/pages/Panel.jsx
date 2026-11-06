import { useEffect, useState } from 'react';

function Panel() {
  const [estado, setEstado] = useState('Consultando...');

  useEffect(() => {
    fetch('/api/health')
      .then((respuesta) => {
        if (!respuesta.ok) {
          throw new Error(`Error HTTP ${respuesta.status}`);
        }
        return respuesta.json();
      })
      .then((datos) => setEstado(datos.status))
      .catch(() => setEstado('Sin conexión con el servidor'));
  }, []);

  return (
    <div className="container mt-5">
      <h1 className="text-primary">Panel de control</h1>
      <p>Estado del servidor: <strong>{estado}</strong></p>
    </div>
  );
}

export default Panel;