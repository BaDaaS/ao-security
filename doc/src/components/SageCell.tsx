import React, { useEffect, useRef } from 'react';

declare global {
  interface Window {
    sagecell: {
      makeSagecell: (options: Record<string, unknown>) => void;
    };
  }
}

interface SageCellProps {
  code: string;
  autoeval?: boolean;
  linked?: boolean;
}

let scriptLoaded = false;
let scriptLoading = false;
const pendingCallbacks: (() => void)[] = [];

function loadSageCellScript(callback: () => void): void {
  if (scriptLoaded && window.sagecell) {
    callback();
    return;
  }

  pendingCallbacks.push(callback);

  if (scriptLoading) {
    return;
  }

  scriptLoading = true;
  const script = document.createElement('script');
  script.src =
    'https://sagecell.sagemath.org/static/embedded_sagecell.js';
  script.onload = () => {
    scriptLoaded = true;
    pendingCallbacks.forEach(cb => cb());
    pendingCallbacks.length = 0;
  };
  document.head.appendChild(script);
}

export default function SageCell({
  code,
  autoeval = false,
  linked = false,
}: SageCellProps): React.ReactElement {
  const cellRef = useRef<HTMLDivElement>(null);
  const initializedRef = useRef(false);

  useEffect(() => {
    if (initializedRef.current || !cellRef.current) {
      return;
    }

    loadSageCellScript(() => {
      if (!cellRef.current || initializedRef.current) {
        return;
      }
      initializedRef.current = true;
      window.sagecell.makeSagecell({
        inputLocation: cellRef.current,
        evalButtonText: 'Run',
        autoeval,
        linked,
        languages: ['sage'],
      });
    });
  }, [autoeval, linked]);

  return (
    <div ref={cellRef}>
      <script type="text/x-sage">{code.trim()}</script>
    </div>
  );
}
