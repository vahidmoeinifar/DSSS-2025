import type {ReactNode} from 'react';

// Import the image at the top
import appScreenshot from '@site/static/img/app.png';

export default function HomepageFeatures(): ReactNode {
  return (
    <section style={{ padding: '3rem 0' }}>
      <div className="container">
        <div className="row">
          <div className="col col--12">
            <div style={{ textAlign: 'center' }}>
              <img 
                src={appScreenshot} 
                alt="GDSS Simulator Interface"
                style={{
                  width: '100%',
                  maxWidth: '900px',
                  borderRadius: '12px',
                  boxShadow: `
                    0 10px 40px rgba(57, 108, 112, 0.2),
                    0 0 0 1px rgba(57, 108, 112, 0.1)
                  `,
                  border: '1px solid rgba(57, 108, 112, 0.2)',
                  transition: 'transform 0.3s ease, box-shadow 0.3s ease',
                  transform: 'translateY(0)',
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.transform = 'translateY(-5px)';
                  e.currentTarget.style.boxShadow = `
                    0 15px 50px rgba(57, 108, 112, 0.3),
                    0 0 0 1px rgba(57, 108, 112, 0.2)
                  `;
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.transform = 'translateY(0)';
                  e.currentTarget.style.boxShadow = `
                    0 10px 40px rgba(57, 108, 112, 0.2),
                    0 0 0 1px rgba(57, 108, 112, 0.1)
                  `;
                }}
              />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}